const { execFileSync, spawnSync } = require("node:child_process");
const { createInterface } = require("node:readline");
const { stdin, stdout } = require("node:process");

function readGit(...args) {
  return execFileSync("git", ["--no-pager", ...args], {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "inherit"],
  }).trimEnd();
}

function copySubject(commit) {
  const subject = readGit(
    "-c",
    "i18n.logOutputEncoding=UTF-8",
    "show",
    "-s",
    "--format=%s",
    commit,
  );
  const commands = {
    win32: [["clip.exe"]],
    darwin: [["pbcopy"]],
    linux: [
      ...(process.env.WAYLAND_DISPLAY ? [["wl-copy"]] : []),
      ["xclip", "-selection", "clipboard"],
      ["xsel", "--clipboard", "--input"],
    ],
  };
  const input =
    process.platform === "win32"
      ? Buffer.from("\uFEFF" + subject, "utf16le")
      : subject;
  for (const [program, ...args] of commands[process.platform] ?? []) {
    if (
      spawnSync(program, args, { input, stdio: ["pipe", "ignore", "ignore"] })
        .status === 0
    ) {
      return;
    }
  }
  throw new Error(
    "Clipboard unavailable. On Linux, install wl-copy, xclip, or xsel.",
  );
}

async function chooseCommand(operation, commit, ask) {
  if (operation === "checkout") {
    const ref = process.env.ZED_GIT_REF;
    if (ref?.startsWith("-")) throw new Error("Invalid checkout reference.");
    return ref
      ? ["checkout", ref, "--"]
      : ["checkout", "--detach", commit, "--"];
  }

  if (operation === "branch") {
    const name = await ask("New branch name (Enter to cancel): ");
    if (!name) return;
    readGit("check-ref-format", "refs/heads/" + name);
    if (name.startsWith("-"))
      throw new Error("Branch names cannot start with a dash.");
    const checkout = await ask(`Check out '${name}' after creating it? [y/N] `);
    if (checkout === undefined) return;
    return checkout?.toLowerCase() === "y"
      ? ["switch", "-c", name, commit]
      : ["branch", "--", name, commit];
  }

  if (operation === "reset") {
    const branch = readGit("rev-parse", "--abbrev-ref", "HEAD");
    console.log(`Reset '${branch}' to the selected commit:`);
    console.log("  1. Soft  - keep changes staged");
    console.log(
      "  2. Mixed - keep changes in the working tree and unstage them",
    );
    console.log("  3. Hard  - discard staged and unstaged tracked changes");
    const selection = await ask("Mode (Enter to cancel): ");
    if (!selection) return;
    const mode = new Map([
      ["1", "--soft"],
      ["2", "--mixed"],
      ["3", "--hard"],
    ]).get(selection);
    if (!mode) throw new Error("Enter 1, 2, or 3.");
    if (
      mode === "--hard" &&
      (
        await ask(`Discard local changes on '${branch}'? [y/N] `)
      )?.toLowerCase() !== "y"
    ) {
      return;
    }
    return ["reset", mode, commit];
  }

  const parents = readGit("show", "-s", "--format=%P", commit)
    .split(" ")
    .filter(Boolean);
  if (operation === "drop") {
    if (parents.length !== 1)
      throw new Error("Drop Commit requires exactly one parent.");
    const ancestor = spawnSync(
      "git",
      ["merge-base", "--is-ancestor", commit, "HEAD"],
      { stdio: "inherit" },
    );
    if (ancestor.error) throw ancestor.error;
    if (ancestor.status === 1)
      throw new Error("The selected commit is outside the current history.");
    if (ancestor.status !== 0)
      throw new Error("Git could not check the selected commit ancestry.");
    if (readGit("rev-list", "--count", "--merges", `${commit}..HEAD`) !== "0") {
      throw new Error(
        "The range to replay contains merge commits. Use interactive rebase to review them.",
      );
    }
    const branch = readGit("rev-parse", "--abbrev-ref", "HEAD");
    const confirm = await ask(
      `Drop the selected commit from '${branch}' and rewrite its history? [y/N] `,
    );
    if (confirm?.toLowerCase() !== "y") return;
    return ["rebase", "--no-update-refs", "--onto", parents[0], commit];
  }

  const args =
    operation === "cherry-pick" ? ["cherry-pick"] : ["revert", "--no-edit"];
  if (parents.length > 1) {
    console.log("Choose the parent to use as the mainline:");
    for (const [index, parent] of parents.entries()) {
      console.log(
        `  ${index + 1}. ${readGit("show", "-s", "--format=%h %s", parent)}`,
      );
    }
    const selection = await ask("Parent number (Enter to cancel): ");
    if (!selection) return;
    if (!/^[1-9]\d*$/.test(selection) || Number(selection) > parents.length) {
      throw new Error(`Enter a parent number between 1 and ${parents.length}.`);
    }
    args.push("-m", selection);
  }
  return [...args, commit];
}

async function main(operation, commit) {
  if (
    ![
      "branch",
      "checkout",
      "cherry-pick",
      "revert",
      "drop",
      "reset",
      "copy-subject",
    ].includes(operation) ||
    !/^(?:[0-9a-f]{40}|[0-9a-f]{64})$/i.test(commit ?? "")
  ) {
    throw new Error("Open a Git Graph action on a selected commit.");
  }
  if (operation === "copy-subject") return copySubject(commit);

  console.log(readGit("show", "-s", "--format=Selected commit: %h %s", commit));
  const initialHead = readGit(
    "rev-parse",
    "HEAD",
    "--symbolic-full-name",
    "HEAD",
  );
  let terminal;
  let lines;
  async function ask(prompt) {
    if (!terminal) {
      terminal = createInterface({
        input: stdin,
        output: stdout,
        // Keep Windows console input in line mode so Node can exit after the prompt.
        terminal: process.platform !== "win32" && Boolean(stdout.isTTY),
      });
      lines = terminal[Symbol.asyncIterator]();
    }
    terminal.setPrompt(prompt);
    terminal.prompt();
    return (await lines.next()).value?.trim();
  }

  let args;
  try {
    args = await chooseCommand(operation, commit, ask);
  } finally {
    terminal?.close();
  }
  if (!args) return;
  if (
    initialHead !== readGit("rev-parse", "HEAD", "--symbolic-full-name", "HEAD")
  ) {
    throw new Error(
      "HEAD changed while the task was open. Run the action again from the current branch.",
    );
  }
  const result = spawnSync("git", args, { stdio: "inherit" });
  if (result.error) throw result.error;
  process.exitCode = result.status ?? 1;
}

module.exports = function run(operation, commit) {
  main(operation, commit).catch((error) => {
    console.error(error.message);
    process.exitCode = error.status || 1;
  });
};

# macOS 配置同步

本机采用复制方式同步。修改仓库后需要重新合并到下表中的配置，不会自动双向更新。覆盖前应备份现有文件，保留本机独有设置、其他主题和片段。

| 仓库文件 | macOS 生效位置 |
| --- | --- |
| `agy ide/settings.jsonc` | `~/Library/Application Support/Antigravity IDE/User/settings.json` |
| `agy ide/keyboards.jsonc` | `~/Library/Application Support/Antigravity IDE/User/keybindings.json` |
| `agy ide/snippets/` | `~/Library/Application Support/Antigravity IDE/User/snippets/` |
| `nvim/` | `~/.config/nvim/` |
| `zed/settings.jsonc`、`zed/keymap.jsonc` | `~/.config/zed/settings.json`、`~/.config/zed/keymap.json` |
| `zed/snippets/` | `~/.config/zed/snippets/` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `typora/themes/` | `~/Library/Application Support/abnerworks.Typora/themes/` |

## 本机适配

- Antigravity IDE 与 Antigravity 是两个应用；这里配置前者。IDE 默认配置中的 `vscode-neovim.useWSL` 必须设为 `false`。
- 本机 Homebrew Neovim 位于 `/opt/homebrew/bin/nvim`，写入 `vscode-neovim.neovimExecutablePaths.darwin`；`vscode-neovim.neovimInitVimPaths.darwin` 指向 `/Users/momo/.config/nvim/init.lua`。其他机器需按实际路径修改。
- IDE 的 `terminal.integrated.defaultProfile.osx` 使用 `zsh`。Windows 专用设置留在仓库中，不做批量替换。
- Zed 的 Vue TypeScript 插件位置改为 `/Users/momo/Library/Application Support/Zed/extensions/work/vue`，依赖已安装的 Vue 扩展；移除从 Windows 带来的 `agent.sandbox_permissions`，不迁移旧机器的免沙箱权限和项目授权。
- 保留原有 Ctrl、Alt 与空格 Leader 按键；Zed 的窗口防误触、Git/AI 面板、合并行和文件树路径操作补充限定 `os == macos` 的 Command 映射，具体按键见根目录 README。macOS 系统快捷键可能优先拦截部分组合，需要在实际使用中核对。
- 本机已通过 `brew install --cask font-jetbrains-mono-nerd-font` 安装 JetBrainsMono Nerd Font（含 Mono 等变体）；保留原有 JetBrains Mono 与 MesloLGS NF 回退。IDE 和 Zed 配置已引用此 Nerd 字体。独立终端需在字体设置中选择 `JetBrainsMono Nerd Font Mono`。
- IDE 默认配置适用于共享默认设置的档案；拥有独立设置的档案（例如 C#）仍保留其独立配置。

Antigravity IDE 另以 `isMac` 限定 `Cmd+Shift+I` 的选区添加/聚焦 AI 命令，以及旧 `Cmd+L`、`Cmd+Shift+L` 的屏蔽；Windows 配置不受新增规则影响。

## Starship 与 zsh

安装 `starship` 后，在 `~/.zshrc` 中停用 Powerlevel10k instant prompt、`ZSH_THEME` 中的 Powerlevel10k 主题和 `.p10k.zsh` 的加载；保留 Oh My Zsh 插件、别名、代理及开发环境变量。最后添加：

```zsh
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(/opt/homebrew/bin/starship init zsh)"
```

打开新的终端会话生效。Powerlevel10k 文件可保留用于恢复，不再加载。主题保留仓库原有 `shuhe` 提示文字。

## 生效与恢复

本次同步的备份位于 `~/.config-backups/momo-<时间>/`，其中 `manifest.json` 记录目标文件与备份对应关系。恢复已有文件时先关闭对应软件，再复制备份回目标路径；没有备份的条目是新建文件，按清单逐个移除即可。Neovim 目录整体备份，避免旧插件声明混入新配置。

IDE 可执行 Reload Window，Zed 可重新打开窗口，Typora 在主题菜单中选择 Claude Like 或 Claude Like Dark。文件同步与语法检查不代表所有 GUI 快捷键、主题及扩展行为均已实际验证。

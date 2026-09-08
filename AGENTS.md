# Agent 工作指南

## 项目是什么

这是 Windows 个人开发环境的配置仓库，集中保存 Antigravity IDE、Neovim、Zed 和 Starship 的配置。主要工作是调整编辑器行为、快捷键和终端外观。

## 开始前

1. 阅读 [README.md](README.md)，了解现有快捷键和使用方式。
2. 查看 `git status --short`，分清已有改动和本次需要修改的文件。
3. 根据下面的表格阅读相关配置，再开始修改。

## 去哪里修改

| 要做的事 | 文件或目录 |
| --- | --- |
| 调整 Antigravity IDE 设置、字体、终端或 Neovim 入口 | `agy ide/settings.jsonc` |
| 调整 IDE 全局快捷键 | `agy ide/keyboards.jsonc`（沿用现有文件名） |
| 调整 Neovim 加载顺序 | `nvim/init.lua` |
| 调整两种 Neovim 使用方式共用的配置、按键 | `nvim/lua/public/` |
| 调整 IDE 中的 Neovim 行为、按键 | `nvim/lua/vsc/` |
| 调整独立运行的 Neovim | `nvim/lua/nvim/` |
| 添加或调整插件声明 | `nvim/lua/plugins/init.lua` |
| 调整具体插件的配置 | `nvim/lua/plugins/config/` |
| 调整 Zed 设置或快捷键 | `zed/settings.json`、`zed/keymap.json` |
| 调整 Starship 主题或 PowerShell 加载方式 | `starship/starship.toml`、`starship/init.ps1` |

`nvim/lazy-lock.json` 保存插件版本。不要为了无关任务更新它。`vscode/` 当前为空，不是配置入口。

## 配置如何加载

Antigravity IDE 的 `vscode-neovim` 扩展通过 `agy ide/settings.jsonc` 指向仓库中的 `nvim/init.lua`。

`nvim/init.lua` 按以下顺序加载：

1. `plugins.init`：引导 lazy.nvim 并声明插件；具体插件可以延迟加载。
2. `public.configPublic` 和 `public.keymapPublic`：加载公共设置与按键。
3. 根据 `vim.g.vscode` 选择分支：在 IDE 中加载 `vsc/`，独立运行时加载 `nvim/`。

Zed 使用自己的配置和内置 Vim 模式，不加载这些 Lua 文件。Starship 单独管理终端提示符，加载方式见 [starship/README.md](starship/README.md)。

## 修改时遵循什么

- 保留空格 Leader 和已有快捷键习惯。涉及多个编辑器时，先明确需要同步哪些编辑器。
- 注意快捷键的模式和作用域，例如 Normal、Visual、终端和编辑器。相似功能不一定能使用相同实现。
- 保留现有剪贴板行为：IDE 中的 Neovim 和 Zed 已接入系统剪贴板。
- 插件声明和具体配置分开放置；保留现有注释与功能分区。
- 只修改请求涉及的内容，不顺手重排整个文件、升级插件或清理无关改动。
- 快捷键或使用方式发生变化时，同步对应 README；详细快捷键表统一放在根目录 README。

## 仓库文件与本机配置

修改仓库文件不一定会立即在软件中生效。先确认软件实际读取的路径，以及配置是直接引用、复制还是链接过去的。

当前 IDE 配置中记录的 Windows 路径：

- Neovim 程序：`D:\Apps\Dev\nvim\bin\nvim.exe`
- Neovim 入口：`D:\Github\MomoPersonalConfiguration\nvim\init.lua`

这些是本机路径，换机器或移动仓库时需要调整。不要在未确认实际使用情况时批量替换路径。

Starship 的 `init.ps1` 可以直接加载同目录的 `starship.toml`，但是否生效取决于本机 PowerShell Profile 是否引用它。具体操作见 Starship README。

## 如何交付

- 根据改动选择必要的检查，不把启动编辑器、安装插件或全仓检查作为固定步骤。首次加载 Neovim 配置可能下载 lazy.nvim 和插件。
- 说明改了什么、在哪里生效，以及哪些行为尚未实际验证。只修改了文件时，不声称软件中的效果已经确认。
- 提交前列出本次改动和拟用的提交信息，等用户确认后再提交。
- 仅暂存和提交本次任务的相关文件，保留用户原有改动。提交遵循 `.agents/skills/git-conventions/SKILL.md`；用户的明确要求优先。
- 未经用户要求，不推送远端。

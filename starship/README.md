# Starship 提示符配置

`starship.toml` 原样归档自 `C:\Users\shuhe\.config\starship.toml`。保留现有马卡龙配色、两行布局、`shuhe` 输入提示符，以及主机名、目录、Git 状态、语言版本、命令耗时和时间模块。

`init.ps1` 提取自本机 PowerShell 7 Profile 的 Starship 加载逻辑，并通过 `$PSScriptRoot` 定位同目录的配置。它不包含原 Profile 的 zoxide、别名或 PSReadLine 设置。

## 从仓库加载

前提：已安装 Starship，终端使用支持配置中图标的 Nerd Font。仓库中的 Antigravity IDE 终端字体已配置为优先使用 JetBrainsMono Nerd Font。

编辑 PowerShell 7 的 `$PROFILE`（本机为 `C:\Users\shuhe\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`），将原有的 Starship 初始化语句替换为：

```powershell
. 'D:\Github\MomoPersonalConfiguration\starship\init.ps1'
```

仓库移动后同步调整此路径。保留 Profile 中其他设置，不要同时保留两处 Starship 初始化。打开新的 PowerShell 会话后加载配置；之后直接修改仓库里的 `starship.toml` 即可。

## 仅恢复配置文件

如果继续使用原 Profile 的加载方式，将 `starship.toml` 复制到 `$HOME\.config\starship.toml`，覆盖前先备份目标文件，并确保没有 `STARSHIP_CONFIG` 指向其他位置。这种方式下，修改仓库配置后需要重新复制。

此次整合仅写入仓库，尚未修改本机 Profile 或切换当前终端的配置来源。

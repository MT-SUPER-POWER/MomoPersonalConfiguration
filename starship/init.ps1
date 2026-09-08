# 在 PowerShell Profile 中点加载本文件，使用仓库中的 Starship 配置。
$env:STARSHIP_CONFIG = Join-Path $PSScriptRoot 'starship.toml'

# 沿用本机 Starship 安装路径；已在 PATH 中时无需重复添加。
if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    $env:Path += ';C:\Program Files\starship\bin'
}

Invoke-Expression (& { (starship init powershell | Out-String) })

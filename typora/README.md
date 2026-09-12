# Typora 主题

保存自己编写的两套 Claude 风格 CSS，首次从本机 `%APPDATA%\Typora\themes\` 原样复制。

| 文件 | 配色 |
| --- | --- |
| `themes/claude-like.css` | 暖色浅色版 |
| `themes/claude-like-dark.css` | 暖色深色版 |

## 使用与同步

Typora 本机主题目录为 `%APPDATA%\Typora\themes\`。仓库中的文件用于版本管理，与本机目录不是自动同步关系。

修改仓库中的主题后，将对应 CSS 复制到本机主题目录，再在 Typora 中选择对应主题；若列表或样式未刷新，重启 Typora。覆盖同名文件前先备份并核对本机是否有新修改。

如果直接在本机主题目录中修改，则将对应 CSS 复制回本仓库后再管理版本。

## 字体与资源

两份 CSS 没有引用本地资源文件，无需复制其他主题目录。字体按 CSS 中的字体列表使用系统已安装字体，未安装时依次回退。

CSS 保留了导出时引用 Google Fonts 的规则；字体未随仓库打包。

本机另有 `claude-like-grey.css` 灰色变体，本次未纳入。

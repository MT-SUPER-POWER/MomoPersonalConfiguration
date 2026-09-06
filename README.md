# 我的个人软件配置存档 (MomoPersonalConfiguration)

本项目是个人开发环境与 IDE / Neovim 配置的集中管理与备份归档仓库。

- **核心编辑器**：Antigravity IDE (基于 VS Code 架构)
- **Vim 驱动**：[vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) (由本地真实 Neovim 实例驱动)
- **配置索引**：`agy ide/settings.json` 通过 `vscode-neovim.neovimInitVimPaths.win32` 索引至 `nvim/init.lua` 统一管理。

---

## 目录结构

```text
MomoPersonalConfiguration/
├── README.md              # 个人配置速查手册（本文件）
├── agy ide/               # Antigravity IDE / VS Code 配置
│   ├── keyboards.jsonc    # IDE 全局自定义按键绑定
│   └── settings.json      # IDE 核心配置文件
├── nvim/                  # Neovim 专属配置
│   ├── init.lua           # Neovim 主入口
│   └── lua/
│       ├── plugins/       # 插件管理与配置解耦
│       │   ├── init.lua   # 仅负责 lazy.nvim 引导与插件下载声明
│       │   └── config/    # 各插件的独立配置 (hop.lua, surround.lua 等)
│       ├── public/        # 公共基础配置 (Leader 键、公共按键)
│       └── vsc/           # VS Code Neovim 专属配置 (keymap & config)
├── zed/                   # Zed 编辑器统一配置
│   ├── keymap.json        # Zed 快捷键映射（对齐 VS Code/Neovim 肌肉记忆）
│   └── settings.json      # Zed 编辑器与 Vim 模式配置
```

---

# ⌨️ 快捷键速查表 (Cheat Sheet)

> **前缀说明**：`<leader>` 键已映射为空格键 <kbd>Space</kbd>。

---

## 一、 VS Code / IDE 全局面板与界面快捷键 (`keyboards.jsonc`)

| 快捷键                                            | 动作 / 命令                   | 功能说明                               |
| :------------------------------------------------ | :---------------------------- | :------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | `closeActiveEditor`           | 关闭当前页面（已屏蔽退出整个软件）     |
| <kbd>Ctrl</kbd> + <kbd>B</kbd>                    | `toggleSidebarVisibility`     | 切换**左侧边栏**（文件树）显示/隐藏    |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>B</kbd>   | `toggleAuxiliaryBar`          | 切换**右侧辅助栏**显示/隐藏            |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>J</kbd>  | `togglePanel`                 | 切换**底部面板**（终端/输出）显示/隐藏 |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>M</kbd>  | `view.problems`               | 快速聚焦**错误与问题面板**             |
| <kbd>Ctrl</kbd> + <kbd>F11</kbd>                  | `toggleMaximizedPanel`        | **最大化 / 恢复**底部面板              |
| <kbd>Ctrl</kbd> + <kbd>F12</kbd>                  | `toggleMaximizedAuxiliaryBar` | **最大化 / 恢复**右侧辅助栏            |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>I</kbd> | `antigravity.toggleChatFocus` | 聚焦唤起 **AI 编程对话**面板           |
| <kbd>Ctrl</kbd> + <kbd>Esc</kbd>                  | `focusActiveEditorGroup`      | 从终端焦点**一键切回代码编辑器**       |

> **安全解绑保护**：已主动解绑 `Ctrl+E`（防与 Vim 下拉冲突）、`Ctrl+K`（防误提交 Git）、`Ctrl+L` 与 `Ctrl+Shift+C`。

---

## 二、 Neovim 核心按键 (`nvim/lua/vsc/keymapVscode.lua`)

### 1. 查找与检索

|   模式    | 快捷键         | 功能说明                                                  |
| :-------: | :------------- | :-------------------------------------------------------- |
| `n` / `x` | <kbd>/</kbd>   | **直接触发 VS Code 原生搜索栏**（选中文本时自动填入选区） |
|    `n`    | `<leader>fw`   | 当前文件内查找（与 `/` 效果一致）                         |
|    `n`    | `<leader>fa`   | 快速检索并打开文件 (Quick Open)                           |
|    `n`    | `<leader>fg`   | 全局文字搜索 (Live Grep / Find in Files)                  |
|    `n`    | `<leader>fb`   | 查看已打开的文件与标签页列表 (Buffers)                    |
|    `n`    | <kbd>Esc</kbd> | 清除高亮标记 (`:nohlsearch`)                              |

---

### 2. 文件与格式化

| 模式 | 快捷键       | 功能说明                                               |
| :--: | :----------- | :----------------------------------------------------- |
| `n`  | `<leader>ff` | **整个文件全局格式化** (`formatDocument`)              |
| `x`  | `<leader>ff` | **仅对当前选中选区进行局部格式化** (`formatSelection`) |
| `n`  | `<leader>fs` | 保存当前文件                                           |

---

### 3. 分屏大小调整（微调模式与预设）

| 快捷键                          | 功能说明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| :------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`<leader>r`** 或 **`<C-w>r`** | **进入分屏微调模式（0ms 瞬发）**，进入后：<br>• <kbd>h</kbd> / <kbd>l</kbd>：左右宽度精细微调（1个单位）<br>• <kbd>j</kbd> / <kbd>k</kbd>：上下高度精细微调（1个单位）<br>• <kbd>H</kbd> / <kbd>L</kbd>：左右宽度大步快调（5个单位）<br>• <kbd>J</kbd> / <kbd>K</kbd>：上下高度大步快调（5个单位）<br>• <kbd>x</kbd>：直接左右对调分屏<br>• <kbd>=</kbd>：平分分屏；<kbd>m</kbd>：最大化分屏<br>• <kbd>Esc</kbd> / <kbd>Enter</kbd> / <kbd>Space</kbd> / <kbd>q</kbd>：**退出微调模式** |
| **`<leader>wm`** 或 `<C-w>_`    | **一键最大化当前分屏** / 再次按下恢复并列                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| **`<leader>w=`** 或 `<C-w>=`    | **一键平分所有窗口宽度** (50% / 50%)                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

---

### 4. 屏幕与文件交换调度（记忆法则：小写文件，大写分屏组）

| 快捷键                       |   功能分类   | 说明                                |
| :--------------------------- | :----------: | :---------------------------------- |
| **`<leader>wx`** 或 `<C-w>x` | **左右对调** | 左右分屏整组位置极速互换            |
| **`<leader>wh`**             |    单文件    | 把当前文件（Tab）甩到 **左侧** 分屏 |
| **`<leader>wl`**             |    单文件    | 把当前文件（Tab）甩到 **右侧** 分屏 |
| **`<leader>wj`**             |    单文件    | 把当前文件（Tab）甩到 **下方** 分屏 |
| **`<leader>wk`**             |    单文件    | 把当前文件（Tab）甩到 **上方** 分屏 |
| **`<leader>wH`**             |   整组分屏   | 整个分屏组 **向左移**               |
| **`<leader>wL`**             |   整组分屏   | 整个分屏组 **向右移**               |
| **`<leader>wJ`**             |   整组分屏   | 整个分屏组 **向下移**               |
| **`<leader>wK`**             |   整组分屏   | 整个分屏组 **向上移**               |

---

### 5. 标签页与窗口光标导航

| 快捷键                               | 功能说明                                         |
| :----------------------------------- | :----------------------------------------------- |
| <kbd>J</kbd> / <kbd>K</kbd>          | 在顶部 Tab 标签页之间**向左 / 向右**快速轮转切换 |
| <kbd>Ctrl</kbd> + <kbd>h/j/k/l</kbd> | 在拆分窗口（Group）之间**直接切换光标焦点**      |
| `<leader>cc`                         | 关闭当前编辑器 Tab                               |
| `<leader>ca`                         | 关闭全部编辑器 Tab                               |

---

### 6. 代码折叠（完美跳跃折叠，不触发展开）

| 快捷键      | 功能说明                                                   |
| :---------- | :--------------------------------------------------------- |
| `j` / `k`   | 光标上下移动（**遇折叠块自动平滑越过，绝不意外展开代码**） |
| `zc` / `zo` | 折叠 / 展开当前代码块                                      |
| `za`        | 切换当前代码块折叠状态                                     |
| `zC` / `zO` | 递归折叠 / 递归展开                                        |
| `zM` / `zR` | 全部折叠 / 全部展开                                        |

---

### 7. 插件特色增强 (纯编辑利器)

#### ① Hop 快速精准跳转 (`smoka7/hop.nvim`)

| 快捷键 | 跳转维度 | 行为说明 |
| :--- | :---: | :--- |
| `<leader><leader>w` | 单词首字母 | 屏幕所有单词首字母打出字母标记，一键飞跳 |
| `<leader><leader>l` | 目标行 | 屏幕所有代码行首打出字母标记，精准跳行 |
| `<leader><leader>co` | 单字符 | 敲一个字符，全屏匹配该字符位置直达 |
| `<leader><leader>cd` | 双字符 | 敲两个连续字符，全屏高精度快速定位 |
| `<leader><leader>f` | 正则/模式 | 输入任意字符串或正则，高亮匹配并快速跳转 |

---

#### ② 符号包裹增强 (`kylechui/nvim-surround`)

支持与各类文本对象搭配使用：

| 动作类型 | 快捷键组合 | 代码示例（`word` 为光标词） | 结果说明 |
| :--- | :--- | :--- | :--- |
| **添加包裹** (`ys`) | `ysiw)` 或 `ysiw(` | `word` ➡️ `(word)` | 为当前单词添加圆括号 |
| **添加引号** (`ys`) | `ysiw"` 或 `ysiw'` | `word` ➡️ `"word"` | 为当前单词添加双引号 |
| **修改包裹** (`cs`) | `cs"'` | `"word"` ➡️ `'word'` | 将双引号替换为单引号 |
| **修改为标签** (`cs`) | `cs'<q>` | `'word'` ➡️ `<q>word</q>` | 将单引号替换为 HTML/XML 标签 |
| **删除包裹** (`ds`) | `ds"` | `"word"` ➡️ `word` | 剔除外层双引号 |
| **删除括号** (`ds`) | `ds(` 或 `ds)` | `(word)` ➡️ `word` | 剔除外层圆括号 |
| **Visual 选区包裹** | 选中文本后按 <kbd>S</kbd> + <kbd>"</kbd> | `[选中文本]` ➡️ `"[选中文本]"` | 将整段选区用目标符号包裹 |

---

#### ③ 强化文本对象 (`echasnovski/mini.ai`)

以动词（`d` 删、`c` 改、`y` 复制、`v` 选中）+ 文本对象组合使用：

| 目标对象 | 关键按键 | 真实场景示例 | 效果与收益 |
| :--- | :---: | :--- | :--- |
| **函数参数** (`a`) | **`daa`** | `fn(user, id█, msg)` ➡️ `fn(user, msg)` | **删除一个参数**，自动收拾多余的逗号与空格，绝不语法报错 |
| **函数参数** (`a`) | **`cia`** | `fn(user, id█, msg)` ➡️ `fn(user, █, msg)` | **清空并修改当前参数**，保留逗号，立刻打字输入新参数 |
| **函数体** (`f`) | **`cif`** | 光标在函数体内任何位置 ➡️ `{ █ }` | **一键清空整个函数实现**，保留大括号，直接重新编写函数逻辑 |
| **整个函数** (`f`) | **`daf`** | 连同 `function ... { ... }` 整块删除 | **彻底删除整个函数定义**（适合重构清理无用代码） |
| **智能引号** (`q`) | **`ciq`** | `'str'`, `"str"`, `` `str` `` ➡️ 引号内清空 | **通杀所有引号**，无需肉眼区分单双引号或反引号，直接改引号内 |
| **智能括号** (`b`) | **`cib`** | `(...)`, `[...]`, `{...}` ➡️ 括号内清空 | **通杀所有括号**，自动匹配最近的一对圆/方/花括号 |
| **下一个目标** (`in`) | **`cin(`** | 光标在行首，直接改该行后方的第一个 `(...)` | **隔空就地修改**，无需先把光标移到括号内部 |

---

## 三、 Zed 编辑器专属适配与对齐 (`zed/settings.json` & `zed/keymap.json`)

Zed 作为高性能 GPU 加速编辑器，同样具备强大的内置 Vim 模式。本仓库已将 Zed 的快捷键模型与 Antigravity IDE / Neovim 实现了 **100% 肌肉记忆对齐**。

- **Windows 本地生效路径**：`%APPDATA%\Zed\`（即 `C:\Users\shuhe\AppData\Roaming\Zed\`）
- **核心配置理念**：保持 Leader 为 <kbd>Space</kbd>，窗口、文件、搜索、折叠完全沿用同一套按键哲学。

### 1. 全局面板与界面控制 (`Workspace` 作用域)

| 快捷键 | Zed Action 命令 | 对应功能说明 |
| :--- | :--- | :--- |
| <kbd>Ctrl</kbd> + <kbd>B</kbd> | `workspace::ToggleLeftDock` | 切换**左侧边栏**（文件项目面板） |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>B</kbd> | `workspace::ToggleRightDock` | 切换**右侧辅助栏** |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>J</kbd> | `workspace::ToggleBottomDock` | 切换**底部终端面板** |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>M</kbd> | `diagnostics::Deploy` | 呼出**错误与诊断面板** |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>I</kbd> | `agent::ToggleFocus` | 聚焦 / 唤起 **Zed AI Assistant** |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | `pane::CloseActiveItem` | 关闭当前页面 |

---

### 2. Zed Vim 模式对齐按键表 (Normal 模式)

| 场景分类 | 快捷键 | Zed Action 命令 | 功能说明 |
| :--- | :--- | :--- | :--- |
| **检索查找** | <kbd>/</kbd> 或 `<leader>fw` | `buffer_search::Deploy` | **触发 Zed 原生文件内搜索栏** |
| **检索查找** | `<leader>fa` | `file_finder::Toggle` | 快速检索打开文件 (Quick Open) |
| **检索查找** | `<leader>fg` | `pane::DeploySearch` | 全局文字搜索 (Live Grep) |
| **检索查找** | `<leader>fb` | `tab_switcher::Toggle` | 查看已打开的标签列表 (Buffers) |
| **文件与格式** | `<leader>fs` | `workspace::Save` | 保存当前文件 |
| **文件与格式** | `<leader>ff` | `editor::Format` | **文档格式化** (Visual 模式下局部格式化) |
| **标签页轮转** | <kbd>J</kbd> / <kbd>K</kbd> | `pane::ActivatePrevItem` / `NextItem` | 快速在顶部 Tab 标签间**向左 / 向右**轮转 |
| **标签页关闭** | `<leader>cc` | `pane::CloseActiveItem` | 关闭当前 Tab |
| **标签页关闭** | `<leader>ca` | `pane::CloseAllItems` | 关闭全部 Tab |
| **跨分屏聚焦** | <kbd>Ctrl</kbd> + <kbd>h/j/k/l</kbd> | `workspace::ActivatePane...` | 在拆分窗口间**直接移动光标焦点** |
| **分屏最大化** | `<leader>wm` | `workspace::ToggleZoom` | **最大化当前分屏** / 再次按下恢复并列 |
| **单文件投掷** | `<leader>w` + <kbd>h/j/k/l</kbd> | `workspace::MoveItemToPaneInDirection` | 将当前单个文件**投掷到左/下/上/右**分屏 |
| **分屏组互换** | `<leader>wx` | `workspace::SwapPaneAdjacent` | **左右分屏整组极速对调** |
| **分屏组移动** | `<leader>w` + <kbd>H/J/K/L</kbd> | `workspace::SwapPane...` | 整个分屏组**向左/下/上/右**对调交换 |
| **代码折叠** | `zc` / `zo` | `editor::Fold` / `editor::UnfoldLines` | 折叠 / 展开当前代码块 |
| **代码折叠** | `za` | `editor::ToggleFold` | 切换代码折叠状态 |
| **代码折叠** | `zM` / `zR` | `editor::FoldAll` / `editor::UnfoldAll` | 全部折叠 / 全部展开 |

---

# 🧠 Vim 文本对象（Text-objects）核心心法指南

> 如果说普通编辑器的操作是**“按住鼠标拖选”**，那么 Vim 的文本对象就是**“语法式命令”**。学会这套公式，您就可以组合出上百种精准编辑动作。

### 1. 核心语法公式

$$\text{操作指令} = \textbf{【动词 Verb】} + \textbf{【介词 Modifier】} + \textbf{【目标对象 Noun】}$$

#### ① 动词（Verb - 你想做什么？）
- **`d`**（Delete）：删除
- **`c`**（Change）：**修改**（删除目标并**立即进入输入模式**，最常用！）
- **`y`**（Yank）：复制
- **`v`**（Visual）：高亮选中

#### ② 介词（Modifier - 选取的范围有多大？）
- **`i`**（**Inside / 内部**）：**只要里面的内容**，保留外层的引号、括号或逗号。
- **`a`**（**Around / 包含**）：**连同外壳一起处理**（包括两端的引号、括号，或者参数后的逗号与空格）。

#### ③ 目标对象（Noun - 你要对谁动手？）
- **基础文本**：`w`（单词 Word）、`s`（句子 Sentence）、`p`（段落 Paragraph）
- **基础符号**：`"`（双引号）、`'`（单引号）、`(` 或 `)`（圆括号）、`{` 或 `}`（花括号）、`[` 或 `]`（方括号）、`t`（HTML/XML 标签 Tag）
- **`mini.ai` 专属增强**：
  - `a`（函数入参 Argument，自动处理逗号）
  - `f`（函数 Function）
  - `q`（通杀任何单/双/反引号 Quote）
  - `b`（通杀任何圆/方/花括号 Bracket）

---

### 2. `i` (Inside) 与 `a` (Around) 的直观对照

以字符串 `"hello world"` 和函数调用 `fn(a, b, c)` 为例：

| 初始代码（光标在单词上） | 操作指令 | 处理后结果 | 核心区别 |
| :--- | :---: | :--- | :--- |
| `"hel█lo world"` | **`di"`** | `""` | **只删内容**，保留外层的双引号 |
| `"hel█lo world"` | **`da"`** | *(完全消失)* | **连皮带肉**，连同两边的双引号一起删除 |
| `fn(user, ag█e, msg)` | **`cia`** | `fn(user, █, msg)` | **保留逗号**，只把参数清空等待打入新内容 |
| `fn(user, ag█e, msg)` | **`daa`** | `fn(user, msg)` | **连同逗号空格抹平**，直接把整个参数剔除 |
| `{ let x = 1█; return x; }` | **`ci{`** 或 **`cif`**| `{ █ }` | **保留大括号**，清空内部代码立刻重写 |
| `{ let x = 1█; return x; }` | **`da{`** 或 **`daf`**| *(完全消失)* | **整块删除**，连同大括号甚至函数头一起拔掉 |

---

### 3. 日常写代码最高频“组合拳” TOP 10

| 场景需求 | 快捷键组合 | 读法助记 |
| :--- | :---: | :--- |
| **修改当前单词** | **`ciw`** | Change Inside Word（清空当前词并打字） |
| **删除当前单词（清理空格）** | **`daw`** | Delete Around Word（连同词后的空格一起删） |
| **快速修改任何引号里的文字** | **`ciq`** | Change Inside Quote（无需看是单引号还是双引号） |
| **快速修改任何括号里的内容** | **`cib`** | Change Inside Bracket（不管是圆括号还是大括号） |
| **删除函数入参（自动收拾逗号）**| **`daa`** | Delete Around Argument（重构删入参神器） |
| **修改函数入参（保留逗号）** | **`cia`** | Change Inside Argument（重写入参神器） |
| **推翻重写整个函数实现** | **`cif`** | Change Inside Function（一键清空函数体） |
| **整块删除废弃函数** | **`daf`** | Delete Around Function（连函数声明带体整块删） |
| **复制整个引号里的内容** | **`yiq`** 或 **`yi"`** | Yank Inside Quote（纯文本直接进剪贴板） |
| **快速选中 HTML/JSX 标签内部** | **`cit`** | Change Inside Tag（清空 `<div>...</div>` 内部） |


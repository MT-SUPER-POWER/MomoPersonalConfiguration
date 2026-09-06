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
└── zed/                   # Zed 编辑器预留配置
```

---

# ⌨️ 快捷键速查表 (Cheat Sheet)

> **前缀说明**：`<leader>` 键已映射为空格键 <kbd>Space</kbd>。

---

## 一、 VS Code / IDE 全局面板与界面快捷键 (`keyboards.jsonc`)

| 快捷键 | 动作 / 命令 | 功能说明 |
| :--- | :--- | :--- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | `closeActiveEditor` | 关闭当前页面（已屏蔽退出整个软件） |
| <kbd>Ctrl</kbd> + <kbd>B</kbd> | `toggleSidebarVisibility` | 切换**左侧边栏**（文件树）显示/隐藏 |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>B</kbd> | `toggleAuxiliaryBar` | 切换**右侧辅助栏**显示/隐藏 |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>J</kbd> | `togglePanel` | 切换**底部面板**（终端/输出）显示/隐藏 |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>M</kbd> | `view.problems` | 快速聚焦**错误与问题面板** |
| <kbd>Ctrl</kbd> + <kbd>F11</kbd> | `toggleMaximizedPanel` | **最大化 / 恢复**底部面板 |
| <kbd>Ctrl</kbd> + <kbd>F12</kbd> | `toggleMaximizedAuxiliaryBar` | **最大化 / 恢复**右侧辅助栏 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>I</kbd> | `antigravity.toggleChatFocus` | 聚焦唤起 **AI 编程对话**面板 |
| <kbd>Ctrl</kbd> + <kbd>Esc</kbd> | `focusActiveEditorGroup` | 从终端焦点**一键切回代码编辑器** |

> **安全解绑保护**：已主动解绑 `Ctrl+E`（防与 Vim 下拉冲突）、`Ctrl+K`（防误提交 Git）、`Ctrl+L` 与 `Ctrl+Shift+C`。

---

## 二、 Neovim 核心按键 (`nvim/lua/vsc/keymapVscode.lua`)

### 1. 查找与检索
| 模式 | 快捷键 | 功能说明 |
| :---: | :--- | :--- |
| `n` / `x` | <kbd>/</kbd> | **直接触发 VS Code 原生搜索栏**（选中文本时自动填入选区） |
| `n` | `<leader>fw` | 当前文件内查找（与 `/` 效果一致） |
| `n` | `<leader>fa` | 快速检索并打开文件 (Quick Open) |
| `n` | `<leader>fg` | 全局文字搜索 (Live Grep / Find in Files) |
| `n` | `<leader>fb` | 查看已打开的文件与标签页列表 (Buffers) |
| `n` | <kbd>Esc</kbd> | 清除高亮标记 (`:nohlsearch`) |

---

### 2. 文件与格式化
| 模式 | 快捷键 | 功能说明 |
| :---: | :--- | :--- |
| `n` | `<leader>ff` | **整个文件全局格式化** (`formatDocument`) |
| `x` | `<leader>ff` | **仅对当前选中选区进行局部格式化** (`formatSelection`) |
| `n` | `<leader>fs` | 保存当前文件 |

---

### 3. 分屏大小调整（微调模式与预设）
| 快捷键 | 功能说明 |
| :--- | :--- |
| **`<leader>r`** 或 **`<C-w>r`** | **进入分屏微调模式（0ms 瞬发）**，进入后：<br>• <kbd>h</kbd> / <kbd>l</kbd>：左右宽度精细微调（1个单位）<br>• <kbd>j</kbd> / <kbd>k</kbd>：上下高度精细微调（1个单位）<br>• <kbd>H</kbd> / <kbd>L</kbd>：左右宽度大步快调（5个单位）<br>• <kbd>J</kbd> / <kbd>K</kbd>：上下高度大步快调（5个单位）<br>• <kbd>x</kbd>：直接左右对调分屏<br>• <kbd>=</kbd>：平分分屏；<kbd>m</kbd>：最大化分屏<br>• <kbd>Esc</kbd> / <kbd>Enter</kbd> / <kbd>Space</kbd> / <kbd>q</kbd>：**退出微调模式** |
| **`<leader>wm`** 或 `<C-w>_` | **一键最大化当前分屏** / 再次按下恢复并列 |
| **`<leader>w=`** 或 `<C-w>=` | **一键平分所有窗口宽度** (50% / 50%) |

---

### 4. 屏幕与文件交换调度（记忆法则：小写文件，大写分屏组）
| 快捷键 | 功能分类 | 说明 |
| :--- | :---: | :--- |
| **`<leader>wx`** 或 `<C-w>x` | **左右对调** | 左右分屏整组位置极速互换 |
| **`<leader>wh`** | 单文件 | 把当前文件（Tab）甩到 **左侧** 分屏 |
| **`<leader>wl`** | 单文件 | 把当前文件（Tab）甩到 **右侧** 分屏 |
| **`<leader>wj`** | 单文件 | 把当前文件（Tab）甩到 **下方** 分屏 |
| **`<leader>wk`** | 单文件 | 把当前文件（Tab）甩到 **上方** 分屏 |
| **`<leader>wH`** | 整组分屏 | 整个分屏组 **向左移** |
| **`<leader>wL`** | 整组分屏 | 整个分屏组 **向右移** |
| **`<leader>wJ`** | 整组分屏 | 整个分屏组 **向下移** |
| **`<leader>wK`** | 整组分屏 | 整个分屏组 **向上移** |

---

### 5. 标签页与窗口光标导航
| 快捷键 | 功能说明 |
| :--- | :--- |
| <kbd>J</kbd> / <kbd>K</kbd> | 在顶部 Tab 标签页之间**向左 / 向右**快速轮转切换 |
| <kbd>Ctrl</kbd> + <kbd>h/j/k/l</kbd> | 在拆分窗口（Group）之间**直接切换光标焦点** |
| `<leader>cc` | 关闭当前编辑器 Tab |
| `<leader>ca` | 关闭全部编辑器 Tab |

---

### 6. 代码折叠（完美跳跃折叠，不触发展开）
| 快捷键 | 功能说明 |
| :--- | :--- |
| `j` / `k` | 光标上下移动（**遇折叠块自动平滑越过，绝不意外展开代码**） |
| `zc` / `zo` | 折叠 / 展开当前代码块 |
| `za` | 切换当前代码块折叠状态 |
| `zC` / `zO` | 递归折叠 / 递归展开 |
| `zM` / `zR` | 全部折叠 / 全部展开 |

---

### 7. 插件特色增强

#### ① Hop 快速精准跳转 (`smoka7/hop.nvim`)
- `<leader><leader>w`：按单词首字母跳转（Hint Words）
- `<leader><leader>l`：按行跳转（Hint Lines）
- `<leader><leader>co`：单字符搜索跳转
- `<leader><leader>cd`：双字符搜索跳转
- `<leader><leader>f`：输入字符串正则匹配跳转

#### ② 符号包裹 (`tpope/vim-surround`)
- `cs"'`：将 `"hello"` 改为 `'hello'`
- `ds"`：删除引号，`"hello"` 变为 `hello`
- `ysiw)`：将当前词用括号包裹，变为 `(hello)`
- Visual 模式选中后按 <kbd>S</kbd> + <kbd>"</kbd>：为选中区域添加外层引号

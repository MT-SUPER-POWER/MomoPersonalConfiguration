-- * ==========================================================
-- *            VSCode Neovim Behavior Configuration
-- * ==========================================================
local has_vscode, vscode = pcall(require, 'vscode')
if not has_vscode then
    return
end

-- 1. 将 Neovim 内部的通知统一桥接到 VS Code 右下角通知栏
vim.notify = vscode.notify

-- 2. 剪贴板集成：默认 Vim 寄存器与 VS Code / Windows 系统剪贴板共用内容
if vim.g.vscode_clipboard then
    vim.g.clipboard = vim.g.vscode_clipboard
    vim.opt.clipboard:append("unnamedplus")
end

-- 3. 解决 VS Code 中 j/k 移动意外触发展开折叠（Issue #58 核心方案）
-- 原理：Neovim 内部只感知真实行号，不知道 VS Code 折叠了哪些行。
-- 如果用 Neovim 自身的 j/k 移入折叠行，VS Code 会强制把折叠展开。
-- 官方推荐方案：在无数字前缀时，将光标移动交给 VS Code 原生的 cursorMove 命令，
-- cursorMove 在视觉行（wrappedLine）模型上移动，会直接跳过折叠区域，绝不展开折叠！
local function moveCursor(direction)
    return function()
        if vim.v.count == 0 then
            local mode = vim.api.nvim_get_mode().mode
            local is_visual = (mode == 'v' or mode == 'V' or mode == '\22')
            vscode.action('cursorMove', {
                args = { {
                    to = direction,
                    by = 'wrappedLine',
                    value = 1,
                    select = is_visual,
                } }
            })
            return '<Ignore>'
        else
            return direction == 'down' and 'j' or 'k'
        end
    end
end

vim.keymap.set({ 'n', 'x' }, 'j', moveCursor('down'), { expr = true, silent = true, desc = 'Move down respecting folds' })
vim.keymap.set({ 'n', 'x' }, 'k', moveCursor('up'), { expr = true, silent = true, desc = 'Move up respecting folds' })

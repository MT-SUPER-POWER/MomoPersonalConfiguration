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
-- Normal/字符选区沿用 cursorMove；V 必须由 Neovim 自身维护模式和锚点。
local function moveVisualLine(direction)
    local current = vim.fn.line('.')
    local count = vim.v.count1
    -- 只读取视口。写入 editor.selection 会触发扩展 start_visual，将 V 转成 v。
    local ranges = vscode.eval([[
        const editor = vscode.window.activeTextEditor;
        return editor ? editor.visibleRanges.map(r => [r.start.line + 1, r.end.line + 1]) : [];
    ]])
    local target = current
    local step = direction == 'down' and 1 or -1
    for _ = 1, count do
        target = math.max(1, math.min(vim.api.nvim_buf_line_count(0), target + step))
        -- 可见范围之间的缺口是折叠内容；视口外不能当成折叠。
        for i = 1, #ranges - 1 do
            if target > ranges[i][2] and target < ranges[i + 1][1] then
                target = step == 1 and ranges[i + 1][1] or ranges[i][2]
                break
            end
        end
    end
    if target ~= current then
        vim.cmd.normal({ args = { math.abs(target - current) .. (step == 1 and 'j' or 'k') }, bang = true })
    end
end

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

vim.keymap.set('n', 'j', moveCursor('down'), { expr = true, silent = true, desc = 'Move down respecting folds' })
vim.keymap.set('n', 'k', moveCursor('up'), { expr = true, silent = true, desc = 'Move up respecting folds' })
for key, direction in pairs({ j = 'down', k = 'up' }) do
    -- 非 expr 映射允许同步读取后执行原生 motion，避免 textlock 和异步选区竞争。
    vim.keymap.set('x', key, function()
        if vim.fn.mode() == 'V' then
            moveVisualLine(direction)
        elseif vim.v.count > 0 then
            vim.cmd.normal({ args = { vim.v.count .. key }, bang = true })
        else
            vscode.action('cursorMove', { args = { to = direction, by = 'wrappedLine', value = 1, select = true } })
        end
    end, { silent = true, desc = 'Extend selection respecting folds' })
end

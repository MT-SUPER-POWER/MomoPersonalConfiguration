-- * ==========================================================
-- *            VSCode Neovim Keybindings
-- * ==========================================================
local has_vscode, vscode = pcall(require, 'vscode')
if not has_vscode then
    return
end

-- -----------------------------------------------------------
-- 1. Telescope 风格全局检索 (<leader>f...)
-- -----------------------------------------------------------
-- 查找文件 (Quick Open)
vim.keymap.set('n', '<leader>fa', function()
    vscode.action('workbench.action.quickOpen')
end, { desc = 'Find Files (Quick Open)' })

-- 全局搜索文本 (Find in Files / Live Grep)
vim.keymap.set('n', '<leader>fg', function()
    vscode.action('workbench.action.findInFiles')
end, { desc = 'Live Grep (Global Search)' })

-- 当前文件内查找
vim.keymap.set('n', '<leader>fw', function()
    vscode.action('actions.find')
end, { desc = 'Find in Current File' })

-- 将 / 键直接映射为触发 VS Code 原生文件内搜索 (与 <leader>fw 一致)
vim.keymap.set({ 'n', 'x' }, '/', function()
    vscode.action('actions.find')
end, { desc = 'Find in Current File (VS Code native)' })

-- 打开的编辑器 / Buffers
vim.keymap.set('n', '<leader>fb', function()
    vscode.action('workbench.action.showAllEditors')
end, { desc = 'Find Buffers / Editors' })

-- -----------------------------------------------------------
-- 2. 文件与格式化 (<leader>f...)
-- -----------------------------------------------------------
-- 格式化文档 (Normal 模式全局格式化，Visual 模式局部选中格式化)
vim.keymap.set('n', '<leader>ff', function()
    vscode.action('editor.action.formatDocument')
end, { desc = 'Format Entire Document' })

vim.keymap.set('x', '<leader>ff', function()
    vscode.action('editor.action.formatSelection')
end, { desc = 'Format Selection' })

-- 保存文件
vim.keymap.set('n', '<leader>fs', function()
    vscode.action('workbench.action.files.save')
end, { desc = 'Save File' })

-- -----------------------------------------------------------
-- 3. 编辑器标签与分屏跳转
-- -----------------------------------------------------------
-- 快速在标签页之间左右切换 (J / K)
vim.keymap.set({ 'n', 'v' }, 'J', function()
    vscode.action('workbench.action.previousEditor')
end, { desc = 'Previous Editor Tab' })

vim.keymap.set({ 'n', 'v' }, 'K', function()
    vscode.action('workbench.action.nextEditor')
end, { desc = 'Next Editor Tab' })

-- 在编辑器、侧栏和底部面板等可见区域间通过 <C-h/j/k/l> 按方向切换焦点。
vim.keymap.set('n', '<C-h>', function()
    vscode.action('workbench.action.navigateLeft')
end, { desc = 'Navigate Left' })

vim.keymap.set('n', '<C-l>', function()
    vscode.action('workbench.action.navigateRight')
end, { desc = 'Navigate Right' })

vim.keymap.set('n', '<C-j>', function()
    vscode.action('workbench.action.navigateDown')
end, { desc = 'Navigate Down' })

vim.keymap.set('n', '<C-k>', function()
    vscode.action('workbench.action.navigateUp')
end, { desc = 'Navigate Up' })

-- 与 Zed 对齐：无需前缀，直接按方向微调当前焦点区域的尺寸。
vim.keymap.set('n', '<C-A-h>', function() vscode.action('workbench.action.decreaseViewWidth') end, { desc = 'Decrease View Width' })
vim.keymap.set('n', '<C-A-j>', function() vscode.action('workbench.action.increaseViewHeight') end, { desc = 'Increase View Height' })
vim.keymap.set('n', '<C-A-k>', function() vscode.action('workbench.action.decreaseViewHeight') end, { desc = 'Decrease View Height' })
vim.keymap.set('n', '<C-A-l>', function() vscode.action('workbench.action.increaseViewWidth') end, { desc = 'Increase View Width' })

-- -----------------------------------------------------------
-- 4. 分屏大小调整与屏幕交换 (<leader>w...)
-- -----------------------------------------------------------
-- 方案四：一键最大化当前分屏 / 恢复 (Toggle Maximize)
vim.keymap.set('n', '<leader>wm', function()
    vscode.action('workbench.action.toggleEditorWidths')
end, { desc = 'Toggle Maximize Current Window' })

-- 方案四：一键均分所有窗口宽度 (Even Widths)
vim.keymap.set('n', '<leader>w=', function()
    vscode.action('workbench.action.evenEditorWidths')
end, { desc = 'Even Editor Widths' })

-- 快速交换：左右分屏对调
local function swap_groups()
    vscode.action('workbench.action.moveActiveEditorGroupRight')
end
vim.keymap.set('n', '<leader>wx', swap_groups, { desc = 'Swap Editor Groups' })
vim.keymap.set('n', '<C-w>x', swap_groups, { desc = 'Swap Editor Groups' })

-- 【单文件】跨分屏移动 (小写 h / j / k / l)
vim.keymap.set('n', '<leader>wh', function()
    vscode.action('workbench.action.moveEditorToLeftGroup')
end, { desc = 'Move File to Left Group' })

vim.keymap.set('n', '<leader>wl', function()
    vscode.action('workbench.action.moveEditorToRightGroup')
end, { desc = 'Move File to Right Group' })

vim.keymap.set('n', '<leader>wj', function()
    vscode.action('workbench.action.moveEditorToBelowGroup')
end, { desc = 'Move File to Below Group' })

vim.keymap.set('n', '<leader>wk', function()
    vscode.action('workbench.action.moveEditorToAboveGroup')
end, { desc = 'Move File to Above Group' })

-- 【整个分屏组】移动/对调 (大写 H / J / K / L)
vim.keymap.set('n', '<leader>wH', function()
    vscode.action('workbench.action.moveActiveEditorGroupLeft')
end, { desc = 'Move Group Left' })

vim.keymap.set('n', '<leader>wL', function()
    vscode.action('workbench.action.moveActiveEditorGroupRight')
end, { desc = 'Move Group Right' })

vim.keymap.set('n', '<leader>wJ', function()
    vscode.action('workbench.action.moveActiveEditorGroupDown')
end, { desc = 'Move Group Down' })

vim.keymap.set('n', '<leader>wK', function()
    vscode.action('workbench.action.moveActiveEditorGroupUp')
end, { desc = 'Move Group Up' })

-- 兼容 Vim 原生整组移动习惯 (<C-w> + 大写)
vim.keymap.set('n', '<C-w>H', function() vscode.action('workbench.action.moveActiveEditorGroupLeft') end, { desc = 'Move Group Left' })
vim.keymap.set('n', '<C-w>L', function() vscode.action('workbench.action.moveActiveEditorGroupRight') end, { desc = 'Move Group Right' })
vim.keymap.set('n', '<C-w>J', function() vscode.action('workbench.action.moveActiveEditorGroupDown') end, { desc = 'Move Group Down' })
vim.keymap.set('n', '<C-w>K', function() vscode.action('workbench.action.moveActiveEditorGroupUp') end, { desc = 'Move Group Up' })

-- 方案二：分屏微调模式 (Submode / Hydra Mode)
-- 独立绑定到 <leader>r (Resize) 与 <C-w>r，与 <leader>w 彻底解耦，0ms 瞬发无延迟！
-- 进入调整模式后：
-- - 单按 h / j / k / l 连续微调 (1个单位)
-- - 单按 H / J / K / L 快速大幅调整 (5个单位)
-- - 按 x 对调左右分屏，按 = 均分窗口，按 m 切换最大化
-- - 按 Esc、Enter、空格或 q 退出模式
local function enter_resize_mode()
    print("-- 分屏微调模式: [h/j/k/l] 步进, [H/J/K/L] 大步, [x] 对调, [=] 均分, [m] 最大化, [Esc/空格] 退出 --")
    while true do
        local ok, key = pcall(vim.fn.getcharstr)
        if not ok or key == '\27' or key == '\r' or key == ' ' or key == 'q' then
            break
        elseif key == 'h' or key == '<Left>' then
            vscode.action('workbench.action.decreaseViewWidth')
        elseif key == 'l' or key == '<Right>' then
            vscode.action('workbench.action.increaseViewWidth')
        elseif key == 'j' or key == '<Down>' then
            vscode.action('workbench.action.increaseViewHeight')
        elseif key == 'k' or key == '<Up>' then
            vscode.action('workbench.action.decreaseViewHeight')
        elseif key == 'H' then
            for _ = 1, 5 do vscode.action('workbench.action.decreaseViewWidth') end
        elseif key == 'L' then
            for _ = 1, 5 do vscode.action('workbench.action.increaseViewWidth') end
        elseif key == 'J' then
            for _ = 1, 5 do vscode.action('workbench.action.increaseViewHeight') end
        elseif key == 'K' then
            for _ = 1, 5 do vscode.action('workbench.action.decreaseViewHeight') end
        elseif key == 'x' then
            vscode.action('workbench.action.moveActiveEditorGroupRight')
        elseif key == '=' then
            vscode.action('workbench.action.evenEditorWidths')
        elseif key == '_' or key == 'm' then
            vscode.action('workbench.action.toggleEditorWidths')
        else
            break
        end
        vim.cmd('redraw')
    end
    print("")
end

vim.keymap.set('n', '<leader>r', enter_resize_mode, { desc = 'Enter Window Resize Mode' })
vim.keymap.set('n', '<C-w>r', enter_resize_mode, { desc = 'Enter Window Resize Mode' })

-- -----------------------------------------------------------
-- 4. 编辑器关闭操作 (<leader>c...)
-- -----------------------------------------------------------
-- 关闭当前编辑器
vim.keymap.set('n', '<leader>cc', function()
    vscode.action('workbench.action.closeActiveEditor')
end, { desc = 'Close Current Editor' })

-- 关闭所有编辑器
vim.keymap.set('n', '<leader>ca', function()
    vscode.action('workbench.action.closeAllEditors')
end, { desc = 'Close All Editors' })

-- -----------------------------------------------------------
-- 5. 代码折叠 (对齐 VS Code 原生折叠能力)
-- -----------------------------------------------------------
vim.keymap.set('n', 'zM', function()
    vscode.action('editor.foldAll')
end, { desc = 'Fold All' })

vim.keymap.set('n', 'zR', function()
    vscode.action('editor.unfoldAll')
end, { desc = 'Unfold All' })

vim.keymap.set('n', 'zc', function()
    vscode.action('editor.fold')
end, { desc = 'Fold' })

vim.keymap.set('n', 'zC', function()
    vscode.action('editor.foldRecursively')
end, { desc = 'Fold Recursively' })

vim.keymap.set('n', 'zo', function()
    vscode.action('editor.unfold')
end, { desc = 'Unfold' })

vim.keymap.set('n', 'zO', function()
    vscode.action('editor.unfoldRecursively')
end, { desc = 'Unfold Recursively' })

vim.keymap.set('n', 'za', function()
    vscode.action('editor.toggleFold')
end, { desc = 'Toggle Fold' })

-- -----------------------------------------------------------
-- 7. 悬停提示与快速文档 (Hover / Quick Doc)
-- -----------------------------------------------------------
-- Ctrl+Q 或 gh 唤起 / 聚焦悬停文档提示窗口
vim.keymap.set('n', '<C-q>', function()
    vscode.action('editor.action.showHover')
end, { desc = 'Show / Focus Hover Documentation' })

vim.keymap.set('n', 'gh', function()
    vscode.action('editor.action.showHover')
end, { desc = 'Show / Focus Hover Documentation' })

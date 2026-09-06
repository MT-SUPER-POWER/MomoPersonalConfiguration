-- * ====================== VSCODE-NEOVIM PLUGIN CONFIG ======================

-- ? HOW TO USE: https://github.com/vscode-neovim/vscode-multi-cursor.nvim

local cursors = require('vscode-multi-cursor')

-- 默认配置
local k = vim.keymap.set
k({ 'n', 'x' }, 'mc', cursors.create_cursor, { expr = true, desc = 'Create cursor' })
k({ 'n' }, 'mcc', cursors.cancel, { desc = 'Cancel/Clear all cursors' })
k({ 'n', 'x' }, 'mi', cursors.start_left, { desc = 'Start cursors on the left' })
k({ 'n', 'x' }, 'mI', cursors.start_left_edge, { desc = 'Start cursors on the left edge' })
k({ 'n', 'x' }, 'ma', cursors.start_right, { desc = 'Start cursors on the right' })
k({ 'n', 'x' }, 'mA', cursors.start_right, { desc = 'Start cursors on the right' })
k({ 'n' }, '[mc', cursors.prev_cursor, { desc = 'Goto prev cursor' })
k({ 'n' }, ']mc', cursors.next_cursor, { desc = 'Goto next cursor' })
k({ 'n' }, 'mcs', cursors.flash_char, { desc = 'Create cursor using flash' })
k({ 'n' }, 'mcw', cursors.flash_word, { desc = 'Create selection using flash' })

-- 多光标操作 > 二次封装默认配置
vim.keymap.set('n', '<leader>p', 'mciw#<Cmd>nohl<CR>', {
    remap = true,
    desc = "多光标选择当前单词, 并跳转到上一个"
})
vim.keymap.set('n', '<leader>n', 'mciw*<Cmd>nohl<CR>', {
    remap = true,
    desc = "多光标选择当前单词, 并跳转到下一个"
})
vim.keymap.set('n', '<leader>x', 'mcl', {
    remap = true,
    desc = "取消当前光标所在单词的多光标选择"
})

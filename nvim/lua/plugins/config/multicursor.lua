local cursors = require('vscode-multi-cursor')
cursors.setup({ default_mappings = true, no_selection = false })

-- 原地选中/取消当前单词；插件会切换已有范围，其余记录保持不变。
vim.keymap.set('n', '<leader>ws', function()
    local position = vim.api.nvim_win_get_cursor(0)
    vim.cmd.normal({ args = { 'mciw' }, bang = false })
    vim.api.nvim_win_set_cursor(0, position)
end, { desc = 'Multi-cursor: toggle current word without moving' })

-- 记录当前单词，然后跳到下一个/上一个同名词；仍留在 Normal 模式。
-- 跳到的位置只是候选：再次按 wn/wN 才会记录它，按 we 不会自动加入候选。
vim.keymap.set('n', '<leader>wn', 'mciw*<Cmd>nohlsearch<CR>', {
    remap = true, desc = 'Multi-cursor: mark word and find next',
})
vim.keymap.set('n', '<leader>wN', 'mciw#<Cmd>nohlsearch<CR>', {
    remap = true, desc = 'Multi-cursor: mark word and find previous',
})
-- 跳过当前候选，仅移动，不新增选区。
vim.keymap.set('n', '<leader>w>', '*<Cmd>nohlsearch<CR>', { desc = 'Multi-cursor: skip forward' })
vim.keymap.set('n', '<leader>w<', '#<Cmd>nohlsearch<CR>', { desc = 'Multi-cursor: skip backward' })
-- 支持任意位置/文本对象：Normal 下继续输入 iw 等对象，Visual 下直接记录选区。
vim.keymap.set({ 'n', 'x' }, '<leader>wc', cursors.create_cursor, {
    expr = true, desc = 'Multi-cursor: mark selection or text object',
})
vim.keymap.set('n', '<leader>we', cursors.start_left, { desc = 'Multi-cursor: edit marked selections' })
vim.keymap.set('n', '<leader>wq', cursors.cancel, { desc = 'Multi-cursor: clear marked selections' })
-- 全选直接进入原生插入模式；输入文字替换所有匹配，Esc 结束。
vim.keymap.set({ 'n', 'x' }, '<leader>wa', function()
    local vscode = require('vscode')
    vscode.with_insert(function()
        vscode.action('editor.action.selectHighlights')
    end)
end, { desc = 'Multi-cursor: edit all matching selections' })

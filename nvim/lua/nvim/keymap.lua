-- * ====================== NEOVIM CONFIG ======================

-- ? 使用 <C-hjkl> 在分屏窗口间跳转（无需先按 <C-w>）
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to below window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to above window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

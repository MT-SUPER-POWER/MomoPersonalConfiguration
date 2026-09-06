-- 确保 mapleader 在所有 require 之前设置
vim.g.mapleader = " "

-- ! 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(lazypath)


-- 插件列表
require("lazy").setup({
    {
        -- ? DOC: https://gist.github.com/wilon/ac1fc66f4a79e7b0c161c80877c75c94
        "tpope/vim-surround",
    },
    {
        -- ? DOC: https://github.com/smoka7/hop.nvim
        "smoka7/hop.nvim",
        config = function()
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
            -- hotPattern keymaps
            vim.keymap.set('', '<leader><leader>w', require 'hop'.hint_words, { desc = 'Hop: Jump to word' })
            vim.keymap.set('', '<leader><leader>l', require 'hop'.hint_lines, { desc = 'Hop: Jump to line' })
            vim.keymap.set('', '<leader><leader>co', require 'hop'.hint_char1, { desc = 'Hop: Jump to single character' })
            vim.keymap.set('', '<leader><leader>cd', require 'hop'.hint_char2, { desc = 'Hop: Jump to two characters' })

            -- 正则 / 模式匹配跳转
            vim.keymap.set('n', '<leader><leader>f', function()
                local hop = require('hop')
                hop.hint_patterns({}, vim.fn.input('Hop Pattern: '))
            end, {
                desc = "Hop: 以字符串进行正则匹配跳转"
            })
        end
    },
    {
        'vscode-neovim/vscode-multi-cursor.nvim',
        event = 'VeryLazy',
        cond = vim.g.vscode, -- NOTE: Loading only if in VSCode Neovim extension
        opts = {}
    }
})

-- * ====================== PLUGIN CONFIG ======================

if vim.g.vscode then
    require("plugins.VSmultiCursor")
end

-- * ==========================================================
-- *            Lazy.nvim Plugin Loader (下载与声明)
-- * ==========================================================
-- 确保 mapleader 在所有插件加载前初始化
vim.g.mapleader = " "

-- 1. 自动安装 / 引导 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 插件安装声明列表（具体配置解耦至 lua/plugins/config/ 目录中）
require("lazy").setup({
    -- agyIDE：在 Normal 模式积累选区，再交给 VS Code 原生多光标编辑。
    {
        "vscode-neovim/vscode-multi-cursor.nvim",
        cond = not not vim.g.vscode,
        config = function()
            require("plugins.config.multicursor")
        end,
    },
    -- 现代化纯 Lua 符号包裹插件 (ysiw, cs, ds)
    {
        "kylechui/nvim-surround",
        version = "*", -- 锁定最新稳定版本
        event = "VeryLazy",
        config = function()
            require("plugins.config.surround")
        end,
    },

    -- 快速精准跳转插件
    {
        "smoka7/hop.nvim",
        config = function()
            require("plugins.config.hop")
        end,
    },

    -- 强化文本对象插件 (daa, cia, cif, ciq 等)
    {
        "echasnovski/mini.ai",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("plugins.config.ai")
        end,
    },
})

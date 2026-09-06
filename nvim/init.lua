local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h"):gsub("\\", "/")
vim.opt.runtimepath:prepend(config_dir)
vim.opt.packpath:prepend(config_dir)
package.path = config_dir .. "/lua/?.lua;" .. config_dir .. "/lua/?/init.lua;" .. package.path
-- * ====================== INITIALTION ENTRANCE ======================

-- ! 插件的优先级要高于下面的配置，因为有些插件会覆盖默认的配置，所以要先加载插件，再加载配置
require("plugins.init")

-- 加载公共配置
require("public.configPublic")
require("public.keymapPublic")

-- Vscode 专属配置
if vim.g.vscode then
    require("vsc.keymapVscode")
    require("vsc.configVscode")
-- Neovim 专属配置
else
    require("nvim.keymap")
    require("nvim.config")
end

-- * ==========================================================
-- *            Hop.nvim Plugin Configuration
-- * ==========================================================
local has_hop, hop = pcall(require, "hop")
if not has_hop then
    return
end

hop.setup({
    keys = "etovxqpdygfblzhckisuran",
})

-- -----------------------------------------------------------
-- Hop 快速跳转快捷键
-- -----------------------------------------------------------
-- 按单词首字母跳转
vim.keymap.set("", "<leader><leader>w", hop.hint_words, { desc = "Hop: Jump to word" })

-- 按行跳转
vim.keymap.set("", "<leader><leader>l", hop.hint_lines, { desc = "Hop: Jump to line" })

-- 按单个字符匹配跳转
vim.keymap.set("", "<leader><leader>co", hop.hint_char1, { desc = "Hop: Jump to single character" })

-- 按双字符匹配跳转
vim.keymap.set("", "<leader><leader>cd", hop.hint_char2, { desc = "Hop: Jump to two characters" })

-- 交互式输入正则 / 模式匹配跳转
vim.keymap.set("n", "<leader><leader>f", function()
    hop.hint_patterns({}, vim.fn.input("Hop Pattern: "))
end, { desc = "Hop: Pattern search jump" })

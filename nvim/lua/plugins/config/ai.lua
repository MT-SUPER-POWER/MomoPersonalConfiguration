-- * ==========================================================
-- *            Mini.ai Plugin Configuration (强化文本对象)
-- * ==========================================================
local has_ai, ai = pcall(require, "mini.ai")
if not has_ai then
    return
end

ai.setup({
    -- 搜索文本对象的最大行数范围
    n_lines = 500,
})

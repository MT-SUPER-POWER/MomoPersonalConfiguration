-- Headless regression: real mappings and Neovim selection, mocked VS Code viewport only.
local ranges = { { 1, 12 } }
package.loaded.vscode = {
    notify = function() end,
    eval = function(code)
        assert(not code:find('editor.selection', 1, true), 'must not replace the selection')
        assert(not code:find('executeCommand', 1, true), 'must not move the VS Code cursor')
        return ranges
    end,
    action = function() error('Visual Line must not call cursorMove') end,
}
dofile('nvim/lua/vsc/configVscode.lua')
local lines = { 'first long line', 'x', '', 'four', 'five longer', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'last' }
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
local function keys(input)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(input, true, false, true), 'xt', false)
end
local function check(label, start, input, anchor, active)
    keys('<Esc>')
    vim.api.nvim_win_set_cursor(0, { start, 0 })
    keys('V' .. input)
    assert(vim.fn.mode() == 'V', label .. ': lost Visual Line')
    assert(vim.fn.line('v') == anchor, label .. ': anchor moved')
    assert(vim.fn.line('.') == active, label .. ': wrong active line')
    keys('y')
    assert(vim.fn.getregtype('"') == 'V', label .. ': yank is not linewise')
    local expected = {}
    for i = math.min(anchor, active), math.max(anchor, active) do expected[#expected + 1] = lines[i] end
    assert(vim.deep_equal(vim.fn.getreg('"', 1, true), expected), label .. ': incomplete lines')
end
check('down', 1, 'jj', 1, 3)
check('up', 5, 'kk', 5, 3)
check('reverse across anchor', 5, 'jjkkkk', 5, 3)
check('count', 1, '3j', 1, 4)
check('EOF', 12, 'j', 12, 12)
check('BOF', 1, 'k', 1, 1)
ranges = { { 1, 3 }, { 8, 12 } }
check('fold down', 3, 'j', 3, 8)
check('fold up', 8, 'k', 8, 3)
check('fold reverse', 3, 'jkj', 3, 8)
check('fold count', 2, '3j', 2, 9)
print('PASS: 10 Visual Line cases, native mode, anchor and full-line yank')

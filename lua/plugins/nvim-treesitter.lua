-- Simlar as "[{" & "]}" in vim, but use treesitter to handle more language
-- direction: 1 = forward, -1 = backword. 
local my_move = function(direction)
    local ok, parser = pcall(vim.treesitter.get_parser, nil, vim.bo.filetype)
    if not ok then
        if direction == -1 then
            vim.cmd.normal("[{")
        else
            vim.cmd.normal("]}")
        end
        vim.print( "No tree-sitter parser, fallback to use `{`, `}` match")
        return
    end

    local root = parser:parse()[1]:root()
    local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
    local cursor_node = root:descendant_for_range(lnum - 1, col, lnum - 1)
    local cur_node = cursor_node
    local target_l, target_c = nil, nil
    while cur_node do
        local sl, sc, el, ec = cur_node:range()
        if direction == -1 then
            if sl ~= lnum - 1 then
                target_l = sl
                target_c = sc
                break
            end
        else
            if el ~= lnum - 1 then
                target_l = el
                target_c = ec
                break
            end
        end
        cur_node = cur_node:parent()
    end

    if target_l ~= nil then
        local lines = vim.fn.line('$')
        target_l = target_l + 1
        if target_l + 1 > lines then
            target_l = lines
        end
        vim.cmd.normal("m'") -- set jump list
        vim.api.nvim_win_set_cursor(0, { target_l, target_c })
    end
end

vim.keymap.set({ 'n', 'v' }, '{', function()
    my_move(-1)
end)
vim.keymap.set({ 'n', 'v' }, '}', function ()
    my_move(1)
end)

return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,
            }
        end
    }
}

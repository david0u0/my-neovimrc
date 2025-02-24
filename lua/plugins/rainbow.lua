vim.g.rainbow_active = 1
return {
    "luochen1990/rainbow",
    config = function()
        vim.api.nvim_create_autocmd('BufReadPost', {
            pattern = '*',
            command = 'RainbowToggleOn',
        })
    end
}

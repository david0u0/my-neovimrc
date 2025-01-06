vim.g.ctrlp_working_path_mode = 0
vim.g.ctrlp_show_hidden = 1
vim.g.ctrlp_mruf_relative = 1 --make ctrlp find mru in working dir

-- Quickly find and open a recently opened file
vim.keymap.set('n', '<Leader>f', '<cmd>CtrlPMRU<cr>')

-- Quickly find and open a buffer
vim.keymap.set('n', '<Leader>b', '<cmd>CtrlPBuffer<cr>')

-- Quickly find and open a file in the current working directory
vim.g.ctrlp_map = '<C-p>'

vim.g.ctrlp_max_height = 20
vim.g.ctrlp_custom_ignore = 'node_modules\\|^\\.DS_Store\\|^\\.git\\|target'

return {
    "kien/ctrlp.vim",
}

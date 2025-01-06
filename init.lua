vim.g.mapleader = ","

require("config.lazy")
require("lazy").setup("plugins")

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd.colorscheme('slate')

vim.keymap.set('n', '<C-L>', '<C-W>l')
vim.keymap.set('n', '<C-K>', '<C-W>k')
vim.keymap.set('n', '<C-J>', '<C-W>j')
vim.keymap.set('n', '<C-H>', '<C-W>h')

vim.keymap.set('n', '<Leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<Leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<Leader>o', '<cmd>only<cr>')

vim.keymap.set('n', '<Leader>tt', '<cmd>tab split<cr>')
vim.keymap.set('n', '<Leader>to', '<cmd>tabonly<cr>')
vim.keymap.set('n', 'gr', 'gT') -- left tab

vim.keymap.set('n', '<Leader>l', '<cmd>bNext<cr>')
vim.keymap.set('n', '<Leader>h', '<cmd>bprevious<cr>')

vim.opt.statuscolumn='%#NonText#%{&nu&&(v:virtnum==0)?v:lnum:""}' ..
'%#LineNr#%{&rnu&&(v:relnum!=0 && v:virtnum==0)?" ".v:relnum:""}'

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})


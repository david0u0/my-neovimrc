vim.g.mapleader = ","

require("config.lazy")
require("lazy").setup("plugins")
require("config.local_config")

vim.opt.mouse = ""
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.cmd.colorscheme('slate')

vim.keymap.set('n', '<C-L>', '<C-W>l')
vim.keymap.set('n', '<C-K>', '<C-W>k')
vim.keymap.set('n', '<C-J>', '<C-W>j')
vim.keymap.set('n', '<C-H>', '<C-W>h')

vim.keymap.set({'n', 'v'}, '0', '^')
vim.keymap.set({'n', 'v'}, '-', 'g_')

vim.keymap.set('n', '<Leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<Leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<Leader>o', '<cmd>only<cr>')
vim.keymap.set({'n', 'v'}, 'g;', '<Plug>Sneak_,')
vim.keymap.set({'n', 'v'}, '{', '[{')
vim.keymap.set({'n', 'v'}, '}', ']}')

vim.keymap.set('n', '<Leader>tt', '<cmd>tab split<cr>')
vim.keymap.set('n', '<Leader>to', '<cmd>tabonly<cr>')
vim.keymap.set('n', 'gr', 'gT') -- left tab
-- NOTE: g<tab>: Go to the latest accessed tab page

vim.keymap.set('n', '<Leader>l', '<cmd>bNext<cr>')
vim.keymap.set('n', '<Leader>h', '<cmd>bprevious<cr>')

vim.opt.statuscolumn='%#LineNr#%{&nu&&(v:virtnum==0)?v:lnum:""}' ..
'%#NonText#%{&rnu&&(v:relnum!=0 && v:virtnum==0)?" ".v:relnum:""}'

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

vim.keymap.set('n', '<Leader>cd', ':cd <C-r>=expand("%:p:h")<cr><c-f>F/')

vim.keymap.set('n', 'gd', '<C-]>')
vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')


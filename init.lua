vim.g.mapleader = ","

vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.mouse = ""
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.foldcolumn = '2'
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.cmd.colorscheme('slate')

vim.keymap.set('n', '<C-L>', '<C-W>l')
vim.keymap.set('n', '<C-K>', '<C-W>k')
vim.keymap.set('n', '<C-J>', '<C-W>j')
vim.keymap.set('n', '<C-H>', '<C-W>h')
vim.keymap.set('n', '<Leader>.', '<cmd>noh<cr>')

vim.keymap.set({ 'n', 'v' }, '0', '^')
vim.keymap.set({ 'n', 'v' }, '-', 'g_')

vim.keymap.set('n', '<Leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<Leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<Leader>o', '<cmd>only<cr>')
vim.keymap.set({ 'n', 'v' }, 'g;', '<Plug>Sneak_,')

vim.keymap.set('n', '<Leader>tt', '<cmd>tab split<cr>')
vim.keymap.set('n', '<Leader>to', '<cmd>tabonly<cr>')
vim.keymap.set('n', '<Leader>tc', '<cmd>tabclose<cr>')
vim.keymap.set('n', 'gr', 'gT') -- left tab
-- NOTE: g<tab>: Go to the latest accessed tab page

vim.opt.statuscolumn = '%#LineNr#%{&nu&&(v:virtnum==0)?v:lnum:""}' ..
    '%#NonText#%{&rnu&&(v:relnum!=0 && v:virtnum==0)?" ".v:relnum:""}'

vim.api.nvim_create_autocmd('BufReadPost', {
	desc = 'Open file at the last position it was edited earlier',
	pattern = '*',
	command = 'silent! normal! g`"zv',
})
vim.api.nvim_create_autocmd('CursorHold', {
	desc = 'Update buffer when file content change',
	pattern = '*',
	command = 'checktime',
})

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 6

local goto_lsp_root = function()
	local dirs = vim.lsp.buf.list_workspace_folders()
	if #dirs > 0 then
		vim.cmd.cd(dirs[1])
	end
end
vim.keymap.set('n', '<Leader>cr', goto_lsp_root)
vim.keymap.set('n', '<Leader>cd', ':cd <C-r>=expand("%:p:h")<cr><c-f>F/')

vim.keymap.set('n', 'gd', '<C-]>')
vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')
vim.keymap.set('n', 'gu', '<cmd>lua vim.lsp.buf.references()<cr>')
vim.keymap.set({'n', 'v'}, '=', 'gq')

vim.api.nvim_create_user_command('BufOnly', function(opts)
    local tablist = {}
    for i = 1,vim.fn.tabpagenr('$') do
        local buflist = vim.fn.tabpagebuflist(i)
        for j=1,#buflist do
            tablist[#tablist+1] = buflist[j]
        end
    end
    local n_wiped = 0
    local n_mod = 0
    for i = 1,vim.fn.bufnr('$') do
        if vim.fn.bufexists(i) ~= 0 then
            local is_active = false
            for j = 1,#tablist do
                if tablist[j] == i then
                    is_active = true
                    break
                end
            end
            if not is_active then
                if vim.fn.getbufvar(i, "&mod") ~= 0 then
                    n_mod = n_mod + 1 -- though inactive, it's modified, so no wiping
                else
                    n_wiped = n_wiped + 1
                    vim.cmd.bwipeout(i)
                end
            end
        end
    end
    local msg = string.format("%d buffers are wiped out, and %d modified buffers are skipped", n_wiped, n_mod)
    if n_wiped == 0 then
        require("notify")(msg, "error")
    else
        require("notify")(msg)
    end
end, {
    nargs = "*",
    desc = "Wipe all buffer but the active ones in tabs"
})

require("config.lazy")
require("lazy").setup("plugins")
require("local.config")

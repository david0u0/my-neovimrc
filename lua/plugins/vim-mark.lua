vim.g.mw_no_mappings = 1

return {
	"inkarkat/vim-mark",
	dependencies = {
		"inkarkat/vim-ingo-library",
	},
	config = function()
		vim.keymap.set('n', '<Leader>m', '<plug>MarkSet')
		vim.keymap.set('x', '<Leader>m', '<plug>MarkSet')
		vim.keymap.set('n', '<Leader>r', '<plug>MarkRegex')
		vim.keymap.set('x', '<Leader>r', '<plug>MarkRegex')
		vim.keymap.set('n', '<Leader>N', '<plug>MarkClear')
		vim.keymap.set('n', '<Leader>/', '<plug>MarkSearchAnyNext')
		vim.keymap.set('n', '<Leader>?', '<plug>MarkSearchAnyPrev')
		vim.keymap.set('n', '<Leader>*', '<plug>MarkSearchCurrentNext')
		vim.keymap.set('n', '<Leader>#', '<plug>MarkSearchCurrentPrev')
	end,
}

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup {}
		vim.keymap.set('n', '<Leader>nn', '<cmd>NvimTreeOpen<cr>')
		vim.keymap.set('n', '<Leader>nf', '<cmd>NvimTreeFindFile!<cr>')
	end,
}

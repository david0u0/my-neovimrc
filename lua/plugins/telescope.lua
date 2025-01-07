local get_visual_text = function()
	if 'v' ~= vim.fn.mode() then
		return ""
	end
	local reg_value_backup = vim.fn.getreg('"')
	vim.cmd.normal('vgvy')
	local visual_text = vim.fn.getreg('"')
	vim.fn.setreg('"', reg_value_backup)
	return visual_text
end

local trigger_grep = function()
	local visual_text = get_visual_text()
	vim.api.nvim_feedkeys(':TelescopeGrep -w ' .. visual_text, 'm', true)
end

vim.api.nvim_create_user_command('TelescopeGrep', function(opts)
	local builtin = require('telescope.builtin')
	local args = opts.fargs
	local word_match = nil
	local search = nil

	vim.print(opts)

	if args[1] == "-w" then
		word_match = "-w"
		vim.print(args)
		table.remove(args, 1)
		vim.print(args)
	end
	if #args > 0 then
		search = args[1]
	end

	vim.print(word_match)
	vim.print(search)

	builtin.grep_string({
		search = search,
		word_match = word_match
	})
end, {
	nargs = "*",
	desc = [[
	TelescopeGrep [-w] [pattern]
	- If [-w] is given, search for whole word
	- If [pattern] is given, search for pattern, otherwise use the hovered word
	]]
})

return {
	{ "pbogut/fzf-mru.vim" },
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			telescope = require('telescope')
			telescope.setup()
			telescope.load_extension('fzf_mru')
			telescope.load_extension('fzf')
			vim.keymap.set('n', '<Leader>f', '<cmd>Telescope fzf_mru current_path<cr>')
			vim.keymap.set('n', '<Leader>j', '<cmd>Telescope marks<cr>')
			vim.keymap.set('n', '<Leader>b', '<cmd>Telescope buffers<cr>')
			vim.keymap.set({ 'n', 'v' }, '<Leader>g', trigger_grep, {
				desc = [[Prepare for TelescopeGrep command.
				1. If in visual mode, use the selected text for pattern
				2. If in normal mode, no pattern]]
			})
			vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files<cr>')
		end
	}
}

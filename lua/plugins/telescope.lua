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

	if args[1] == "-w" then
		word_match = "-w"
		table.remove(args, 1)
	end
	if #args > 0 then
		search = table.concat(args, " ")
	end

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

local bufonly = function(prompt_bufnr, is_normal)
    vim.cmd.BufOnly()
    require("telescope.actions").close(prompt_bufnr)
    if is_normal then
        require("telescope.builtin").buffers({ initial_mode = "normal" })
    else
        require("telescope.builtin").buffers({ })
    end
end

local fzf_mru = function()
    local files = vim.fn['fzf_mru#mrufiles#list']('raw')
    local missing_list = {}
    for _, path in pairs(files) do
        local missing = vim.fn.filereadable(path) == 0
        if missing then
            table.insert(missing_list, path)
            local msg = string.format("file %s is missing", path)
            require("notify")(msg)
        end
    end
    vim.fn['fzf_mru#mrufiles#remove'](missing_list)

    vim.cmd('Telescope fzf_mru current_path')
end

return {
	{ "pbogut/fzf-mru.vim" },
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local telescope = require('telescope')
			telescope.setup({
                defaults = {
                    layout_strategy = 'vertical',
                    path_display = {"shorten"},
                },
				pickers = {
					buffers = {
						mappings = {
							i = {
								["<c-d>"] = "delete_buffer",
								["<c-o>"] = function(prompt_bufnr) bufonly(prompt_bufnr, false) end
							},
							n = {
								["<c-d>"] = "delete_buffer",
								["<c-o>"] = function(prompt_bufnr) bufonly(prompt_bufnr, true) end
							}
						}
					}
				},
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
			})
			telescope.load_extension('fzf_mru')
			telescope.load_extension('fzf')
			vim.keymap.set('n', '<Leader>f', '<cmd>Telescope fzf_mru current_path<cr>')
			vim.keymap.set('n', '<Leader>f', fzf_mru)
			vim.keymap.set('n', '<Leader>j', '<cmd>Telescope jumplist<cr>')
			vim.keymap.set('n', '<Leader>b', '<cmd>Telescope buffers<cr>')
			vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files<cr>')
			vim.keymap.set({ 'n', 'v' }, '<Leader>g', trigger_grep, {
				desc = [[Prepare for TelescopeGrep command.
				1. If in visual mode, use the selected text for pattern
				2. If in normal mode, no pattern]]
			})
		end
	}
}

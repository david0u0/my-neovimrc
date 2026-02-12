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

function do_fzf_mru(opts)
    opts = opts or {}
    -- TODO: I don't know why I can't just set the mapping in `setup({extensions = ...})`
    opts.attach_mappings = function(_, map)
        map("i", "<c-o>", function(prompt_bufnr)
            tidy_mru(prompt_bufnr, false)
        end)
        map("n", "<c-o>", function(prompt_bufnr)
            tidy_mru(prompt_bufnr, true)
        end)
        return true
    end
    require('telescope').extensions.fzf_mru.current_path(opts)
end

function tidy_mru(prompt_bufnr, is_normal)
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

    require("telescope.actions").close(prompt_bufnr)
    if is_normal then
        do_fzf_mru({ initial_mode = "normal" })
    else
        do_fzf_mru()
    end
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
			})
			telescope.load_extension('fzf_mru')
			vim.keymap.set('n', '<Leader>f', do_fzf_mru)
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

local source = {}

function source:complete(_, callback)
	local cmp = require("cmp")
	local response = {}

	local loaded_snippets = require("config.snippet")[vim.bo.filetype] or {}
	for key in pairs(loaded_snippets) do
		local snippet = loaded_snippets[key]
		local body
		if type(snippet.body) == "table" then
			body = table.concat(snippet.body, "\n")
		else
			body = snippet.body
		end

		local prefix = snippet.prefix
		if type(prefix) == "table" then
			for _, p in ipairs(prefix) do
				table.insert(response, {
					label = p,
					kind = cmp.lsp.CompletionItemKind.Snippet,
					insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
					insertTextMode = cmp.lsp.InsertTextMode.AdjustIndentation,
					insertText = body,
					data = {
						prefix = p,
						body = body,
					},
				})
			end
		else
			table.insert(response, {
				label = prefix,
				kind = cmp.lsp.CompletionItemKind.Snippet,
				insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
				insertTextMode = cmp.lsp.InsertTextMode.AdjustIndentation,
				insertText = body,
				data = {
					prefix = prefix,
					body = body,
				},
			})
		end
	end
	callback(response)
end
function source:execute(completion_item, callback)
	callback(completion_item)
end

return {
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and
				vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local cmp = require("cmp")
			cmp.setup {
                preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end
				},
				mapping = {
					["<CR>"] = cmp.mapping(function(fallback)
						-- This mapping is mainly for snippets, because snippets won't (and shouldn't) auto expand
						-- So if there are multiple candidates we have to hit <CR>
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
						    if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							else
								cmp.select_next_item()
							end
						elseif vim.snippet.active({ direction = 1 }) then
							vim.schedule(function()
								vim.snippet.jump(1)
							end)
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif vim.snippet.active({ direction = -1 }) then
							vim.schedule(function()
								vim.snippet.jump(-1)
							end)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'snippets' },
				})
			}
			cmp.register_source("snippets", source)
		end
	}
}

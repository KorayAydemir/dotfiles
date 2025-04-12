M = {}

local function find_from_keywords()
	local bufnr = vim.api.nvim_get_current_buf()
	local lang = vim.bo.filetype
    -- [intentional-no-pcall]
	local parser = vim.treesitter.get_parser(bufnr, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = vim.treesitter.query.parse(
		lang,
		[[
            (import_statement
             (string) @import_source)
        ]]
	)

	local results = {}
	for id, node in query:iter_captures(root, bufnr, 0, -1) do
		local parent = node:parent() -- import_statement
		local start_row, _, end_row, _ = parent:range()
		local from_row, _, _, _ = node:range()

		table.insert(results, {
			start_line = start_row + 1,
			end_line = end_row + 1,
			from_line = from_row + 1,
		})
	end
	return results
end

M.format_imports = function ()
	local bufnr = vim.api.nvim_get_current_buf()
	local imports = find_from_keywords()

	if #imports == 0 then
		return
	end

	for _, imp in ipairs(imports) do
		local lines = vim.api.nvim_buf_get_lines(bufnr, imp.start_line - 1, imp.end_line, false)
		local target_col = 48

		local new_lines = {}
		for i, line in ipairs(lines) do
			local absolute_line = imp.start_line + i - 1
			if absolute_line == imp.from_line then
				local before, from_part = line:match("^(.-)%s+(from%s+.+)$")
				if before and from_part then
					before = vim.trim(before)
					local pad_len = target_col - vim.fn.strdisplaywidth(before)
					local padding = string.rep(" ", math.max(1, pad_len))
					line = before .. padding .. from_part
				end
			end
			table.insert(new_lines, line)
		end

		vim.api.nvim_buf_set_lines(bufnr, imp.start_line - 1, imp.end_line, false, new_lines)
	end
end

return M

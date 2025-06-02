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

local function wrap_and_align_import(line, target_col)
	local before, from_part = line:match("^(.-)%s+(from%s+.+)$")
	if not before or not from_part then return { line } end

	before = vim.trim(before)
	local before_width = vim.fn.strdisplaywidth(before)

	if before_width >= target_col then
		local default = before:match("^import%s+([%w_$]+)%s*,")
		local specifiers = before:match("{(.-)}")
		local lines = {}
		local import_line = "import"

		if default then
			import_line = import_line .. " " .. default .. ", {"
		elseif specifiers then
			import_line = import_line .. " {"
		end

		table.insert(lines, import_line)

		if specifiers then
			for spec in specifiers:gmatch("[^,%s]+") do
				table.insert(lines, "    " .. spec .. ",")
			end
			lines[#lines] = lines[#lines]:gsub(",$", "") -- remove last comma
		end

		table.insert(lines, "}" .. string.rep(" ", target_col - 1) .. from_part)
		return lines
	else
		local pad_len = target_col - before_width
		local padding = string.rep(" ", math.max(1, pad_len))
		return { before .. padding .. from_part }
	end
end

M.format_imports = function ()
	local bufnr = vim.api.nvim_get_current_buf()
	local imports = find_from_keywords()

	if #imports == 0 then return end

    table.sort(imports, function(a, b)
        return a.start_line > b.start_line -- process bottom-up
    end)
	for _, imp in ipairs(imports) do
		local lines = vim.api.nvim_buf_get_lines(bufnr, imp.start_line - 1, imp.end_line, false)
		local target_col = 48

		local new_lines = {}
		for i, line in ipairs(lines) do
			local absolute_line = imp.start_line + i - 1
			if absolute_line == imp.from_line then
				local wrapped_lines = wrap_and_align_import(line, target_col)
				vim.list_extend(new_lines, wrapped_lines)
			else
				table.insert(new_lines, line)
			end
		end

		vim.api.nvim_buf_set_lines(bufnr, imp.start_line - 1, imp.end_line, false, new_lines)
	end
end

return M

----



M = {}

local function is_consecutive(arr)
  if #arr <= 1 then
    return false
  end

  table.sort(arr)
  for i = 2, #arr do
    if arr[i] ~= arr[i-1] + 1 then
      return false
    end
  end
  return true
end

local consecutive_line_blocks_of_jsx_element_attributes = {}
---@return table
local function find_equal_sign_lines()
	local ts = vim.treesitter
	-- [intentional-no-pcall]
	local parser = ts.get_parser()

	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse(
		"javascript",
		[[ 
            (lexical_declaration (variable_declarator) @equals)
           (assignment_expression) @equals

           (jsx_self_closing_element) @jsx_element
           (jsx_opening_element)      @jsx_element
        ]]
	)

	local results = {}
	for id, node in query:iter_captures(root, 0) do
		local capture_name = query.captures[id]

		if capture_name == "equals" then
			local second_child = node:named_child(1)

            -- it matched a variable declaration without equals sign.
            -- e.g. `let myVariable;`
			if second_child == nil then goto continue end

			if second_child:type() ~= "arrow_function" then
				local start_row, _, _, _ = node:range() -- 0 indexed
				local line = start_row + 1
				table.insert(results, line)
			end
		end

		if capture_name == "jsx_element" then
            local line_group = {}
            for child, name in node:iter_children() do
                if name == 'attribute' then
                    local start_row, _,_,_ = child:range()
                    local line = start_row + 1
                    table.insert(line_group, line)
                end
            end
            if is_consecutive(line_group) then
                for k,v in ipairs(line_group) do
                    print(k.." = "..v)
                end
                vim.list_extend(consecutive_line_blocks_of_jsx_element_attributes, line_group)
            end
		end

        ::continue::
	end
	return results
end

---@return table
local function get_consecutive_line_blocks(lines)
	local consecutives = {}
	local consecutive = {}
	for i, line in ipairs(lines) do
		if line + 1 == lines[i + 1] then
			if #consecutive == 0 then
				table.insert(consecutive, line)
			end
			table.insert(consecutive, line + 1)
		else
			if #consecutive > 1 then
				local consecutive_start_end = { start_line = consecutive[1], end_line = consecutive[#consecutive] }
				table.insert(consecutives, consecutive_start_end)
			end
			consecutive = {}
		end
	end
	return consecutives
end

---@return table
local function mini_align_equal_signs(lines)
	local mini_align = require("mini.align")
	local equals_modifier = mini_align.config.modifiers["="]
	-- equals_modifier needs pre_justify property to exist
	local steps = { pre_justify = {} }
	local opts = {}
	table.insert(steps.pre_justify, mini_align.gen_step.filter("n==1"))
	equals_modifier(steps, opts)

	return mini_align.align_strings(lines, opts, steps)
end

M.format_equal_signs = function()
	local lines = find_equal_sign_lines()
	local blocks = get_consecutive_line_blocks(lines)
	for _, block in ipairs(blocks) do
		local start_line = block.start_line - 1
		local end_line = block.end_line - 1 + 1 -- -1 for 0 indexing, +1 for nvim_buf.. functions having exclusive end line
		local block_lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

		local aligned = mini_align_equal_signs(block_lines)

		-- Replace original lines with aligned ones
		vim.api.nvim_buf_set_lines(0, start_line, end_line, false, aligned)
	end

	local blocks2 = get_consecutive_line_blocks(consecutive_line_blocks_of_jsx_element_attributes)
	for _, block in ipairs(blocks2) do
		local start_line = block.start_line - 1
		local end_line = block.end_line - 1 + 1 -- -1 for 0 indexing, +1 for nvim_buf.. functions having exclusive end line
		local block_lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

		local aligned = mini_align_equal_signs(block_lines)

		-- Replace original lines with aligned ones
		vim.api.nvim_buf_set_lines(0, start_line, end_line, false, aligned)
	end

end

return M

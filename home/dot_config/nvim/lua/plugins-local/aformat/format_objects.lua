M = {}

local function has_multiple_properties(node)
    local count = 0
    for child in node:iter_children() do
        if child:type() == "pair" then
            count = count + 1
            if count > 1 then return true end
        end
    end
    return false
end

-- Finds all object literals in a JavaScript buffer
local function find_objects_line_ranges()
    local ts = vim.treesitter
    -- [intentional-no-pcall]
	local parser = ts.get_parser()

	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse(
		"javascript",
		[[ 
            (object) @object
        ]]
	)

	local results = {}
	for _, node in query:iter_captures(root, 0) do
		if has_multiple_properties(node) then
			local start_row, _, end_row, _ = node:range() -- 0 indexed
			local start_line = start_row + 1
			local end_line = end_row + 1
			table.insert(results, { start_line = start_line, end_line = end_line })
		end
	end
	return results
end

M.format_objects = function()
	local objects = find_objects_line_ranges() -- 1 indexed/line numbers

	for _, obj in ipairs(objects) do
		local obj_start_line = obj.start_line + 1 - 1 -- -1 for 0 indexing, +1 to get line after object starts
		local obj_end_line = obj.end_line - 1 + 1 -- -1 for 0 indexing, +1 for nvim_buf.. functions having exclusive end line
		local obj_lines = vim.api.nvim_buf_get_lines(0, obj_start_line, obj_end_line, false) -- 0 indexed

		local mini_align = require("mini.align")
		local aligned = mini_align.align_strings(obj_lines, {
			split_pattern = ":",
			justify_side = "left",
			merge_delimiter = " ",
		}, { pre_justify = { mini_align.gen_step.trim() }, pre_split = { mini_align.gen_step.ignore_split() } })

		vim.api.nvim_buf_set_lines(0, obj_start_line, obj_end_line, false, aligned) -- 0 indexed
	end
end

return M

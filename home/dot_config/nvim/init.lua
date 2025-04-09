require("init")

vim.filetype.add({ extension = { es6 = "javascript" } })
vim.filetype.add({ extension = { ejs = "html" } })

local ts = vim.treesitter

-- todo, should run prettier seperately on seperate parts of code to allow redux selectors to span more than 120 chars, but not allow import statements

local function find_from_keywords()
    local bufnr = vim.api.nvim_get_current_buf()
    local lang = vim.bo.filetype
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
local function format_from_keywords()
    local bufnr = vim.api.nvim_get_current_buf()
    local imports = find_from_keywords()

    if #imports == 0 then return end

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

------

local function group_continuous_lines(ranges)
	table.sort(ranges, function(a, b) return a.start_line < b.start_line end)

	local blocks = {}
	local current_block = nil

	for _, r in ipairs(ranges) do
		if current_block == nil then
			current_block = { start_line = r.start_line, end_line = r.end_line }
		elseif r.start_line <= current_block.end_line + 1 then
			-- Extend block
			current_block.end_line = math.max(current_block.end_line, r.end_line)
		else
			-- Push and start new block
			table.insert(blocks, current_block)
			current_block = { start_line = r.start_line, end_line = r.end_line }
		end
	end

	-- Push the last block
	if current_block then table.insert(blocks, current_block) end

	return blocks
end

local function find_js_equal_signs()
	local bufnr = vim.api.nvim_get_current_buf()
	local parser = ts.get_parser(bufnr, "javascript")
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse(
		"javascript",
		[[ 
          (lexical_declaration 
            (variable_declarator 
              name: (_)
              value: [(call_expression) (identifier) (object) (member_expression) (binary_expression) (unary_expression) (string) (number) (ternary_expression) (subscript_expression) (call_expression) (array)]
            )
          ) @equals_assignment

          (assignment_expression
			left: (_)
			right: [(call_expression) (identifier)  (object) (member_expression) (binary_expression) (unary_expression) (string) (number) (ternary_expression) (subscript_expression) (call_expression) (array)]
		  ) @equals_assignment

          (jsx_attribute
              (property_identifier)
              [
                (jsx_expression 
                    [ (call_expression) (identifier)  (object) (member_expression) (binary_expression) (unary_expression) (string) (number) (ternary_expression) (subscript_expression) (call_expression) (array) ]
                ) 
               (call_expression) (identifier)  (object) (member_expression) (binary_expression) (unary_expression) (string) (number) (ternary_expression) (subscript_expression) (call_expression) (array) ]
          ) @jsx_equals

          (jsx_attribute
              (property_identifier)
              [
                (jsx_expression 
                   (arrow_function (formal_parameters)@jsx_equals )
                ) 

               (arrow_function (formal_parameters)@jsx_equals )
            ]
          ) 

        ]]
	)

	local results = {}
	for _, node in query:iter_captures(root, bufnr, 0, -1) do
		local start_row, _, end_row, _ = node:range()
		local start_line = start_row + 1
		local end_line = end_row + 1
		table.insert(results, { start_line = start_line, end_line = end_line })
	end
	return results
end

local function format_equal_signs()
	local objects = find_js_equal_signs()
	local bufnr = vim.api.nvim_get_current_buf()
	local blocks = group_continuous_lines(objects)

	for _, block in ipairs(blocks) do
		-- print(string.format("Equal sign starts at line %d, ends at line %d", block.start_line, block.end_line))

		local start_line = block.start_line - 1 -- -1: nvim_buf_get_lines is 0 indexed
		local obj_lines = vim.api.nvim_buf_get_lines(bufnr, start_line, block.end_line, false)

		local mini_align = require("mini.align")

		local equals_modifier = mini_align.config.modifiers["="]
		-- equals_modifier needs pre_justify property to exist
		local steps = { pre_justify = {} }
		local opts = {}
		table.insert(steps.pre_justify, mini_align.gen_step.filter("n==1"))
		equals_modifier(steps, opts)
		local aligned = mini_align.align_strings(obj_lines, opts, steps)

		-- Replace original lines with aligned ones
		vim.api.nvim_buf_set_lines(bufnr, start_line, block.end_line, false, aligned)
	end
end

-- Finds all object literals in a JavaScript buffer
local function find_js_objects()
	local bufnr = vim.api.nvim_get_current_buf()
	local parser = ts.get_parser(bufnr, "javascript")
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse(
		"javascript",
		[[ 
            (object
                (pair key: (_) value: (_))
            ) @non_empty_object
        ]]
	)

	local results = {}
	for _, node in query:iter_captures(root, bufnr, 0, -1) do
		local start_row, _, end_row, _ = node:range()
		local start_line = start_row + 1
		local end_line = end_row + 1
		table.insert(results, { start_line = start_line, end_line = end_line })
	end
	return results
end

local function format_colons()
	local objects = find_js_objects()
	local bufnr = vim.api.nvim_get_current_buf()
	for _, obj in ipairs(objects) do
		-- print(string.format("Object starts at line %d, ends at line %d", obj.start_line, obj.end_line))

		local start_line = obj.start_line - 1 + 1 -- -1: nvim_buf_get_lines is 0 indexed -- +1: dont get the line where object starts
		local obj_lines = vim.api.nvim_buf_get_lines(bufnr, start_line, obj.end_line, false)

		local mini_align = require("mini.align")

		local aligned = mini_align.align_strings(obj_lines, {
			split_pattern = ":",
			justify_side = "left",
			merge_delimiter = " ",
		}, { pre_justify = { mini_align.gen_step.trim() }, pre_split = { mini_align.gen_step.ignore_split() } })

		-- Replace original lines with aligned ones
		vim.api.nvim_buf_set_lines(bufnr, start_line, obj.end_line, false, aligned)
	end
end

local function autistformat()
	format_colons()
	format_equal_signs()
	format_from_keywords()
end
vim.g.autistformat = autistformat

vim.keymap.set("n", "<leader>fa", autistformat, {
	desc = "Run autistformat",
})

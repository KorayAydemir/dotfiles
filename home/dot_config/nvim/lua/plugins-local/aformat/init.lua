-- aformat (align format)
-- formatter for javascript

-- some unrecoverable errors are not handled so that users can debug easily from stack trace
-- they are annotated with below comment:
-- [intentional-no-pcall]

---------------------------------------

M = {}

M.format = function()
	require("plugins-local.aformat.format_objects").format_objects()
	require("plugins-local.aformat.format_equal_signs").format_equal_signs()
	require("plugins-local.aformat.format_imports").format_imports()
end

return M

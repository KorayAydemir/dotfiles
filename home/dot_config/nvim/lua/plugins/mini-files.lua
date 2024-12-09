local function config()
    local miniFiles = require("mini.files")
    vim.keymap.set("n", "<leader>pv", function() miniFiles.open(vim.api.nvim_buf_get_name(0)) end)
    vim.keymap.set("n", "<leader>pc", function() miniFiles.open() end)
end
return {
    "echasnovski/mini.files",
    config = config,
    version = "*",
    keys = {
        "<leader>pv",
        "<leader>pc"
    },
}

local jdtls = require('jdtls')
local config = {
    cmd = { vim.fn.expand('$HOME/.local/share/nvim/mason/bin/jdtls') },
    settings = {
        java = {
            project = {
                referencedLibraries = {
                    include = {
                        "/home/koray/dev/java-deps/*.jar",
                    }
                },
            }
        }
    }
}
jdtls.start_or_attach(config)

vim.keymap.set("n", "<A-o>", jdtls.organize_imports)
vim.keymap.set("n", "crv", jdtls.extract_variable)
vim.keymap.set("v", "crv", jdtls.extract_variable)
vim.keymap.set("n", "crc", jdtls.extract_constant)
vim.keymap.set("v", "crc", jdtls.extract_constant)
vim.keymap.set("v", "crm", jdtls.extract_method)
vim.keymap.set("n", "crm", jdtls.extract_method)

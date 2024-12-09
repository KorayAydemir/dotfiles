return {
	{ "folke/twilight.nvim", cmd = "Twilight" },
	{
		"vyfor/cord.nvim",
		build = vim.fn.has("macunix") and "./build" or ".\\build",
		event = "VeryLazy",
		opts = {},
	},
    {
        "eandrju/cellular-automaton.nvim",
        cmd = {"CellularAutomaton"},
    }
}

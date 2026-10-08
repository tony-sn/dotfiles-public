return {
	"folke/which-key.nvim",
	opts = {
		icons = {
			mappings = vim.g.have_nerd_font or true,
			keys = vim.g.have_nerd_font and {} or {
				r = "󰓡 ",
			},
			rules = {
				{
					plugin = "telescope-hierarchy.nvim",
					icon = " ", -- nf-oct-telescope
					color = "blue",
				},
			},
		},
	},
}

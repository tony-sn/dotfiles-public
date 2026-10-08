return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		keywords = {
			PERF = { icon = "󰅒 ", color = "#C09DE3", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
			INPUT = { icon = "󰍛 ", color = "#F2B318", alt = { "INPUT", "REQUEST", "REQ" } },
			OUTPUT = { icon = " ", color = "#259390", alt = { "OUTPUT", "RESPONSE", "RES" } },
			PROCESS = { icon = " ", color = "#E06C75", alt = { "PROCESS", "PROCEDURE", "PROC" } },
		},
	},
}

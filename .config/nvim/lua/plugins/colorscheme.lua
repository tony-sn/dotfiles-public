return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		---@type CatppuccinOptions
		---@diagnostic disable: missing-fields
		opts = {
			flavour = "mocha", -- or "latte", "frappe", "macchiato"
			highlight_overrides = {
				all = function(colors)
					return {
						-- Requested Links
						["@variable.javascript"] = { link = "@variable" },
						["@type.javascript"] = { link = "Type" },
						["@type.typescript"] = { link = "Type" },
						["@keyword.import.javascript"] = { link = "Include" },
						["@_jsx_element.javascript"] = { link = "@_jsx_element" },
						["@tag.builtin.javascript"] = { link = "@tag.builtin" },
						["@tag.javascript"] = { link = "@tag" },

						-- Color the { } punctuation in imports
						["@punctuation.bracket"] = { fg = colors.mauve },
						["@punctuation.delimiter"] = { fg = colors.mauve },

						-- Color the named imports (identifiers inside braces)
						["@variable"] = { fg = colors.teal },
						["@variable.import"] = { fg = colors.teal },
						["@variable.parameter"] = { fg = colors.teal },
						["@variable.member"] = { fg = colors.teal },

						-- LSP Semantic Tokens
						["@lsp.type.variable"] = { fg = colors.teal },
						["@lsp.type.parameter"] = { fg = colors.teal },
						["@lsp.type.member"] = { fg = colors.teal },
						["@lsp.type.property"] = { fg = colors.teal },
						["@lsp.type.namespace"] = { fg = colors.yellow },
						["@lsp.type.type"] = { fg = colors.yellow },
						["@lsp.type.class"] = { fg = colors.yellow },
						["@lsp.type.enum"] = { fg = colors.yellow },
						["@lsp.type.interface"] = { fg = colors.yellow },

						-- Module/namespace names
						["@module"] = { fg = colors.yellow },
						["@namespace"] = { fg = colors.yellow },

						-- The 'from' keyword
						["@keyword.import"] = { fg = colors.mauve },

						-- TSX components
						["@lsp.type.component.tsx"] = { fg = colors.blue },
					}
				end,
			},
			auto_integrations = true,
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				colorful_winsep = { color = "lavender" },
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = {
					enabled = true,
					lsp = true,
				},
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				symbols_outline = true,
				snacks = {
					indent_scope_color = "lavender",
					words = {
						enabled = true,
					},
				},
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		specs = {
			{
				"akinsho/bufferline.nvim",
				optional = true,
				opts = function(_, opts)
					if (vim.g.colors_name or ""):find("catppuccin") then
						opts.highlights = require("catppuccin.special.bufferline").get_theme()
					end
				end,
			},
		},
	},
}

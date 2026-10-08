if true then return {} end

return {
  {
    "LazyVim/LazyVim",
    patch = {
      ["lua/lazyvim/plugins/lsp/init.lua"] = {
        {
          {
            -- Replace the broken line with the fixed version
            pattern = "require%(\"mason%-lspconfig%.mappings%.server\"%.).lspconfig_to_package",
            replacement = "require(\"mason-lspconfig\").get_mappings().lspconfig_to_package",
          },
        },
      },
    },
  },
}


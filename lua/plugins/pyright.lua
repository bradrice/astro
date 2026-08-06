-- In lua/user/plugins/pyright.lua (or a similar location)
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off", -- Set type checking mode to 'off' or 'basic'
              -- You can also disable specific diagnostics or warnings
              -- ignoreExternalSources = true,
              -- diagnosticSeverityOverrides = {
              --   reportGeneralTypeIssues = "none",
              --   reportMissingImports = "none",
              -- },
            },
          },
        },
      },
    },
  },
}

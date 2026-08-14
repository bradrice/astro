-- Quiet down pyright: it is here for completion and navigation, not type errors.
--
-- Per-server settings go through AstroLSP's `config` table, which hands them to
-- `vim.lsp.config(server, ...)`. The pre-v5 version of this file set
-- `opts.servers` on `nvim-lspconfig` instead, which AstroNvim's LSP engine does
-- not read.

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable-next-line: missing-fields
    config = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off", -- "off" | "basic" | "standard" | "strict"
              -- Individual diagnostics can be dialed back instead:
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

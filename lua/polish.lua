-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Windows: nvim-treesitter builds parsers with the `tree-sitter` CLI, which
-- looks for MSVC's cl.exe unless CC names another compiler. Point it at gcc.
-- The path must be absolute: given a bare `gcc` the CLI fails with a
-- misleading "parser.dll not found". Set on vim.env so cargo, node-gyp and
-- MSBuild outside nvim are unaffected.
if vim.fn.has "win32" == 1 then
  local gcc = vim.fn.exepath "gcc"
  if gcc ~= "" then vim.env.CC = gcc end
end

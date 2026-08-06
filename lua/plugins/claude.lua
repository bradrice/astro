--- Directory the Claude CLI runs in, which is derived from Neovim's cwd rather
--- than from the current buffer. Mirrors the plugin's own `pushd` target.
local function project_root()
  local cfg = require("claude-code").config
  if cfg.git and cfg.git.use_git_root then
    -- Call the plugin's own helper: `git rev-parse` resolves symlinks, so
    -- reimplementing this with vim.fs.root would key off a different path.
    return require("claude-code.git").get_git_root() or vim.fn.getcwd()
  end
  return vim.fn.getcwd()
end

--- Key this project's terminal is filed under in the plugin's `instances` table.
--- Recomputed on every use: `current_instance` only updates on toggle, so it
--- goes stale as soon as the cwd moves to another project.
local function instance_id()
  local cfg = require("claude-code").config
  if cfg.git and cfg.git.multi_instance then return project_root() end
  return "global"
end

--- Buffer and job of this project's live Claude terminal, or nil if none is
--- running. A buffer whose CLI has exited counts as not running, so callers
--- fall through to toggle(), which replaces it.
local function claude_terminal()
  local cc = require "claude-code"
  local bufnr = cc.claude_code.instances[instance_id()]
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then return end
  local job = vim.b[bufnr].terminal_job_id
  -- jobwait with a 0 timeout returns -1 while the job is still alive.
  if job and vim.fn.jobwait({ job }, 0)[1] == -1 then return bufnr, job end
end

--- Paste text into the running Claude terminal, opening it first if needed.
local function send_to_claude(text)
  local cc = require "claude-code"
  local bufnr, job = claude_terminal()
  local launched = bufnr == nil
  if not bufnr or #vim.fn.win_findbuf(bufnr) == 0 then
    cc.toggle() -- guarded above, so we only ever reach toggle's "open" branch
    bufnr, job = claude_terminal()
  end
  if not job then return vim.notify("Claude Code terminal unavailable", vim.log.levels.WARN) end
  -- Bracketed paste, so the CLI treats this as pasted text rather than
  -- keystrokes: the `@` autocomplete popup does not swallow the path, and
  -- newlines in a selection do not submit the prompt early.
  local payload = "\27[200~" .. text .. "\27[201~"
  if launched then
    -- A freshly spawned CLI drops input until it finishes starting up.
    vim.defer_fn(function() vim.api.nvim_chan_send(job, payload) end, 500)
  else
    vim.api.nvim_chan_send(job, payload)
  end
end

--- Current buffer's path relative to the CLI's cwd, or nil if it has no file.
--- Falls back to the absolute path for buffers outside that root, which the CLI
--- still resolves.
local function rel_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN)
    return nil
  end
  return vim.fs.relpath(project_root(), vim.fn.fnamemodify(path, ":p")) or path
end

--- Send the current file as an `@` reference, optionally tagged with the cursor line.
local function send_file_ref(with_line)
  return function()
    local path = rel_path()
    if not path then return end
    local ref = "@" .. path
    if with_line then ref = ref .. " (line " .. vim.fn.line "." .. ")" end
    send_to_claude(ref .. " ")
  end
end

--- Send the visual selection as a fenced block, tagged with where it came from.
local function send_selection()
  local mode = vim.fn.mode()
  if not mode:match "^[vV\22]" then return end
  local path = rel_path()
  if not path then return end
  -- Read the region while the selection is still live, before leaving visual mode.
  local from, to = vim.fn.getpos "v", vim.fn.getpos "."
  local lines = vim.fn.getregion(from, to, { type = mode })
  local first, last = math.min(from[2], to[2]), math.max(from[2], to[2])
  local where = first == last and ("line " .. first) or ("lines " .. first .. "-" .. last)
  local text = ("@%s (%s)\n```%s\n%s\n```\n"):format(path, where, vim.bo.filetype, table.concat(lines, "\n"))
  vim.api.nvim_feedkeys(vim.keycode "<Esc>", "nx", false)
  send_to_claude(text)
end

return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume" }, -- Lazy load on commands
    keys = {
      -- Map a key to toggle Claude terminal interface easily
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>af", send_file_ref(false), desc = "Send file path to Claude" },
      { "<leader>al", send_file_ref(true), desc = "Send file path + line to Claude" },
      { "<leader>as", send_selection, mode = "x", desc = "Send selection to Claude" },
    },
    config = function()
      require("claude-code").setup {
        -- Add any custom configuration overrides here
      }
    end,
  },
}

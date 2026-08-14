# AstroNvim Template

**NOTE:** This is for AstroNvim v5+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/<your_user>/<your_repository> ~/.config/nvim
```

On Windows the config lives in `%LOCALAPPDATA%\nvim` instead (`~/.config/nvim` is only read
when `XDG_CONFIG_HOME` is set).

#### Start Neovim

```shell
nvim
```

## ⌨️ Claude Code Keymaps

Configured in [`lua/plugins/claude.lua`](lua/plugins/claude.lua) on top of
[greggh/claude-code.nvim](https://github.com/greggh/claude-code.nvim).

### Custom mappings

| Key          | Mode   | Action                                                                       |
| ------------ | ------ | ---------------------------------------------------------------------------- |
| `<leader>ac` | Normal | Toggle the Claude Code terminal                                              |
| `<leader>ar` | Normal | Resume a previous session (`:ClaudeCodeResume`)                              |
| `<leader>aC` | Normal | Continue the last session (`:ClaudeCodeContinue`)                            |
| `<leader>af` | Normal | Send the current file to Claude as `@path`                                   |
| `<leader>al` | Normal | Send the current file as `@path (line N)` using the cursor line              |
| `<leader>as` | Visual | Send the selection as a fenced code block tagged with `@path (lines A-B)`    |

The send mappings open the terminal if it is closed and leave it alone if it is
already visible. Paths are relative to the git root, matching the CLI's working
directory (`git.use_git_root` defaults to `true`). Text is pasted into the prompt
but **not submitted**, so you type your question after it.

### Plugin defaults

These come from the plugin itself, not from this config.

| Key          | Mode            | Action                                    |
| ------------ | --------------- | ----------------------------------------- |
| `<C-,>`      | Normal/Terminal | Toggle the Claude Code terminal           |
| `<leader>cC` | Normal          | Open Claude with `--continue`             |
| `<leader>cV` | Normal          | Open Claude with `--verbose`              |
| `<C-h/j/k/l>`| Terminal        | Move to the window left/down/up/right     |
| `<C-f>`      | Terminal        | Scroll a full page down                   |
| `<C-b>`      | Terminal        | Scroll a full page up                     |

### Commands

`:ClaudeCode` (toggle), `:ClaudeCodeContinue`, `:ClaudeCodeResume`,
`:ClaudeCodeVerbose`, `:ClaudeCodeVersion`.

Note there is no `:ClaudeCodeToggle` — the toggle command is plain `:ClaudeCode`.

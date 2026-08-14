# AstroNvim Template

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 📌 Versions

| | |
| --- | --- |
| Neovim | **0.12.4** (Homebrew: `brew upgrade neovim`) |
| AstroNvim | **v6.0.7**, tracked as `version = "^6"` in [`lua/lazy_setup.lua`](lua/lazy_setup.lua) |
| Plugins | pinned by `lazy-lock.json`; while a `version` is tracked, AstroNvim additionally pins its own tested plugin set via its `lazy_snapshot.lua` |

AstroNvim v6 requires **Neovim 0.11+ stable** — explicitly *not* nightly. It dropped
0.10 support, and on 0.11+ it disables `Comment.nvim` and `nvim-ufo` in favour of
Neovim's native `gc` commenting and folds.

### Upgrading AstroNvim

Bump the `version` constraint in `lua/lazy_setup.lua`, then run `:Lazy sync`
**twice**. The first pass updates AstroNvim itself and brings in its new
`lazy_snapshot.lua`; the second applies the pinned plugin set that snapshot
specifies. After only one pass AstroNvim reports the new major while
`astrocore`/`astrolsp`/`astroui` are still on the old one — v6 needs AstroLSP v4,
so this matters. Afterwards `:Lazy clean` removes plugins the new major no longer
uses.

### Bringing another machine up to date

```shell
git pull
brew upgrade neovim                    # if it is also behind
nvim --headless "+Lazy! sync" +qa      # run twice, per above
nvim --headless "+Lazy! clean" +qa
```

`:Lazy restore` on its own is **not** enough: it pins already-installed plugins to
the lockfile but does not install missing ones, so a machine coming from an older
major ends up without the new major's plugins (going to v5 that was `blink.cmp`,
`snacks.nvim` and `mini.icons`). Use `install` or `sync` first, then `restore` if
you want to land exactly on the committed pins.

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

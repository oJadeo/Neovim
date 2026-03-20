---
title: "Neovim Configuration Summary"
tags:
  - overview
---

# Neovim Configuration Summary

A modern Neovim configuration using lazy.nvim as the plugin manager, focused on Lua development, Markdown note-taking with Obsidian, and Godot game development.

## Directory Structure

```
nvim/
├── init.lua              # Entry point - loads lazy.nvim and modules
├── lazy-lock.json        # Plugin version lock file
├── lua/
│   ├── vim-options.lua   # Vim settings and options
│   ├── config/
│   │   └── autocmds.lua  # Autocommands
│   ├── keymaps/          # Keybinding definitions
│   │   ├── init.lua
│   │   ├── markdown/
│   │   ├── navigate.lua
│   │   └── utility.lua
│   ├── plugins/          # Plugin specifications
│   └── util/
│       └── helpers.lua
├── lsp/
│   └── gdscript.lua      # Godot LSP configuration
└── spell/                # Spell check files
```

## Core Settings

- **Leader:** Space (` `)
- **Local Leader:** Space (` `)
- **Numbers:** Enabled with relative numbers
- **Mouse:** Enabled (`a`)
- **Undo:** Persistent undo file enabled
- **Search:** Case-insensitive (smart case)
- **Scrolloff:** 10 lines

## Plugin Categories

| Category | File | Description |
|----------|------|-------------|
| [AI & Copilot](./ai-copilot.md) | copilot.lua | GitHub Copilot integration |
| [Autocompletion & Snippets](./autocompletion.md) | autocomplete.lua | Blink.cmp + LuaSnip |
| [Autoformatting](./autoformatting.md) | autoformat.lua, none-ls.lua | Conform.nvim formatting |
| [Debugging](./debugging.md) | debugging.lua | DAP with UI |
| [Git Integration](./git.md) | gitsigns.lua | Git signs and utilities |
| [LSP Configuration](./lsp.md) | lsp-config.lua | Language server setup via Mason |
| [Markdown & Notes](./markdown.md) | markdown.lua | Obsidian + render-markdown |
| [Navigation & Files](./navigation.md) | telescope.lua, neo-tree.lua, yazi.lua, alpha.lua | File finding and browsing |
| [Syntax & Editing](./editing.md) | treesitter.lua, mini.lua, guess-indent.lua | Syntax highlighting and text objects |
| [Theme & UI](./ui.md) | theme.lua, lualine.lua, noice.lua, etc. | Visual appearance |
| [Utilities](./utilities.md) | undotree.lua, outline.lua, trouble.lua, utils.lua | Helper tools |

## Key Bindings

See [**Complete Keymaps Reference**](./keymaps.md) for all keybindings.

### Leader Key Groups
- `<leader>s` - Search (Telescope)
- `<leader>t` - Toggle tools
- `<leader>o` - Obsidian
- `<leader>m` - Markdown
- `<leader>e` - Yazi file manager
- `<leader>a` - AI/Copilot
- `<leader>u` - Undotree

### Common Mappings
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle Neo-tree |
| `<leader>f` | Format buffer |
| `<leader>zz` | Zen mode (90 width) |
| `<leader>zZ` | Zen mode (80 width, minimal) |
| `gd` | Go to definition |
| `gr` | Rename |
| `ga` | Code action |

---

## Custom Code Documentation

Detailed documentation for custom Lua modules:

| Document | Description |
|----------|-------------|
| [Filter System](./markdown/filter-system.md) | Telescope picker for filtering markdown by tags/projects |
| [Folding System](./markdown/folding-system.md) | Treesitter-based markdown folding with level keymaps |
| [Navigation System](./markdown/navigation-system.md) | Heading navigation with gk/gj |
| [Spell System](./markdown/spell-system.md) | Multi-language spelling management |
| [Text Styling](./markdown/text-styling.md) | Bold, strikethrough, checkboxes, task completion |
| [Helpers](./markdown/helpers.md) | Utility functions for async/file operations |
| [Godot Integration](./markdown/godot-integration.md) | GDScript debugging, breakpoints, LSP |

---

## Installed Plugins (44 total)

Managed by lazy.nvim with version locking via `lazy-lock.json`.

---
title: "Autoformatting"
tags:
  - formatting
  - keymap
---

# Autoformatting

## Overview

Automatic code formatting on save and on-demand using conform.nvim and none-ls.

## Plugin: conform.nvim

**File:** `lua/plugins/autoformat.lua`

### Features
- Format on save (with filetype exceptions)
- Async formatting support
- LSP format fallback

### Format on Save
- **Timeout:** 500ms
- **Disabled for:** C, C++ (no standardized style)

### Configured Formatters

| Filetype | Formatter(s) |
|----------|--------------|
| Lua | stylua |
| GDScript | gdtoolkit |
| JavaScript | prettierd, prettier (first available) |

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>f` | n, v, x | Format buffer (async) |

### Commands
- `:ConformInfo` - Show conform configuration info

## Plugin: none-ls.nvim

**File:** `lua/plugins/none-ls.lua`

### Features
- General-purpose LSP-like source integration
- Currently configured for stylua formatting

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gf` | n | LSP format |

## Configuration

Both plugins work together:
- `conform.nvim` handles async formatting and format-on-save
- `none-ls.nvim` provides LSP-based formatting via `vim.lsp.buf.format()`

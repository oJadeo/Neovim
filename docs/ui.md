---
title: "Theme & UI"
tags:
  - ui
  - keymap
---

# Theme & UI

## Overview

Visual appearance and user interface enhancements for a polished editing experience.

## Plugin: tokyonight.nvim

**File:** `lua/plugins/theme.lua`

Tokyo Night colorscheme.

### Configuration
- **Style:** storm
- **Transparent:** Enabled (no background color)
- **Terminal colors:** Enabled

### Commands
- `:colorscheme tokyonight-storm` - Set colorscheme

## Plugin: lualine.nvim

**File:** `lua/plugins/lualine.lua`

Statusline plugin.

### Configuration
- **Theme:** codedark

### Dependencies
- **nvim-web-devicons** - File type icons

## Plugin: noice.nvim

**File:** `lua/plugins/noice.lua`

Replacement for UI messages, cmdline, and popupmenu.

### Features
- Better cmdline display
- Message history
- Popup menu enhancement

### Dependencies
- **nui.nvim** - UI components
- **nvim-notify** - Notification view (optional fallback: mini)

## Plugin: which-key.nvim

**File:** `lua/plugins/which-key.lua`

Shows pending keybindings.

### Configuration
- **Delay:** 0ms (instant)
- **Icons:** Based on Nerd Font availability

### Key Groups

| Prefix | Group |
|--------|-------|
| `<leader>s` | Search (n, v) |
| `<leader>t` | Toggle |
| `<leader>h` | Git Hunk (n, v) |
| `<leader>o` | Obsidian |
| `<leader>m` | Markdown |
| `<leader>e` | Yazi |

## Plugin: todo-comments.nvim

**File:** `lua/plugins/todo.lua`

Highlight and search TODO comments.

### Features
- Highlights TODO, FIXME, HACK, etc.
- Signs disabled (no gutter icons)

### Dependencies
- **plenary.nvim** - Utilities

## Plugin: zen-mode.nvim

**File:** `lua/plugins/zenmode.lua`

Distraction-free coding mode.

### Keybindings

| Key | Width | Features |
|-----|-------|----------|
| `<leader>zz` | 90 | Number + relative on |
| `<leader>zZ` | 80 | Number off, no colorcolumn |

### zZ Mode Features
- No line numbers
- No relative numbers
- Colorcolumn hidden

---
title: "Navigation & Files"
tags:
  - navigation
  - keymap
---

# Navigation & Files

## Overview

File navigation, search, and management tools for efficient project exploration.

## Plugin: telescope.nvim

**File:** `lua/plugins/telescope.lua`

### Dependencies
- **plenary.nvim** - Required utility library
- **telescope-ui-select.nvim** - UI select backend
- **telescope-fzf-native.nvim** - Native FZF sorter (requires make)

### Configuration
- **Layout:** Vertical strategy
- **Markdown preview:** Custom render-markdown integration

### Search Keybindings

| Key | Action |
|-----|--------|
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sf` | Search files |
| `<leader>ss` | Search Telescope builtins |
| `<leader>sw` | Search current word (n, v) |
| `<leader>sg` | Search by grep |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Search recent files |
| `<leader>sc` | Search commands |
| `<leader><leader>` | Find existing buffers |
| `<leader>/` | Fuzzy search in buffer |
| `<leader>s/` | Grep in open files |
| `<leader>sn` | Search Neovim config files |

### LSP Navigation (on attach)

| Key | Action |
|-----|--------|
| `grr` | Go to references |
| `gri` | Go to implementation |
| `grd` | Go to definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `grt` | Go to type definition |

## Plugin: neo-tree.nvim

**File:** `lua/plugins/neo-tree.lua`

### Dependencies
- **plenary.nvim** - Utilities
- **image.nvim** - Image preview
- **nvim-web-devicons** - File icons
- **nui.nvim** - UI components

### Keybindings

| Key | Action |
|-----|--------|
| `<C-n>` | Reveal file in filesystem tree (left) |

### Commands
- `:Neotree` - Open file explorer

## Plugin: yazi.nvim

**File:** `lua/plugins/yazi.lua`

Terminal file manager integration with yazi.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>ee` | Open yazi at current file |
| `<leader>ec` | Open yazi in working directory |
| `<leader>et` | Resume last yazi session |

### Internal Keybindings (in yazi)
- `<F1>` - Show help
- `<C-v>` - Open in vertical split
- `<C-x>` - Open in horizontal split

## Plugin: alpha-nvim

**File:** `lua/plugins/alpha.lua`

Dashboard/start screen for Neovim.

### Features
- Startify theme
- Custom ASCII art header
- Recent files
- Sessions

### Dependencies
- **nvim-web-devicons** - File icons

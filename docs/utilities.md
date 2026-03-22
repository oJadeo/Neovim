---
title: "Utilities"
tags:
  - utility
  - keymap
---

# Utilities

## Overview

Helper tools for diagnostics, undo history, and code outline.

## Plugin: undotree

**File:** `lua/plugins/undotree.lua`

Visualize and navigate undo history as a tree.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undotree |

### Features
- Visual undo history tree
- Branch navigation
- Persistent across sessions (via undofile setting)

## Plugin: outline.nvim

**File:** `lua/plugins/outline.lua`

Code outline/symbols sidebar.

### Configuration
- **Symbol folding:** Disabled (autofold_depth: false)

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>to` | Toggle outline |

### Commands
- `:Outline` - Toggle outline
- `:OutlineOpen` - Open outline

## Plugin: trouble.nvim

**File:** `lua/plugins/trouble.lua`

Diagnostics and references list.

### Configuration
- **Icons:** Disabled (text mode)

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle trouble |
| `[t` | Next trouble item |
| `]t` | Previous trouble item |

### Features
- Lists diagnostics, references, quickfix items
- Navigable list with skip_groups option

## Plugin: nvim-nio

**File:** `lua/plugins/utils.lua`

Async IO library used as a dependency for DAP and other async operations.

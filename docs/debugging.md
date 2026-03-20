---
title: "Debugging"
tags:
  - debugging
  - keymap
---

# Debugging

## Overview

Debug Adapter Protocol (DAP) configuration with UI for interactive debugging.

## Plugin: nvim-dap

**File:** `lua/plugins/debugging.lua`

### Dependencies
- **nvim-dap-ui** - Visual debugging interface
- **nvim-nio** - Async IO library

### Features
- Automatic UI open/close on debug session
- Breakpoint management
- Continue/step debugging

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>dt` | Toggle breakpoint |
| `<leader>dc` | Continue/Start debugging |

### Configured Debug Adapters

#### Bash
- **Adapter:** bashdb
- **Filetypes:** `.sh`
- **Requirements:** bash-debug-adapter (via Mason)

#### Godot
- **Adapter:** godot (server)
- **Port:** 6006
- **Filetypes:** GDScript (`.gd`)
- **Usage:** Connects to Godot editor's debug server

## DAP UI

Automatically opens when debugging starts and closes when session ends.

### UI Components
- Scopes
- Watches
- Stacks
- Breakpoints
- Repl

## Mason Requirements

Install via `:Mason`:
- `bash-debug-adapter` - For shell script debugging

## Godot Setup

1. In Godot Editor: Editor → Editor Settings → Network → Debug Adapter
2. Enable the debug adapter on port 6006
3. Start debugging from Neovim with `<leader>dc`

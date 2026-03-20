---
title: "LSP Configuration"
tags:
  - lsp
  - keymap
---

# LSP Configuration

## Overview

Language Server Protocol configuration using nvim-lspconfig with Mason for automatic LSP server installation.

## Plugin: nvim-lspconfig

**File:** `lua/plugins/lsp-config.lua`

### Dependencies
- **mason.nvim** - Package manager for LSP servers
- **mason-lspconfig.nvim** - Bridge between Mason and lspconfig
- **mason-tool-installer.nvim** - Auto-install tools
- **fidget.nvim** - LSP progress notifications
- **blink.cmp** - Completion engine integration

### Configured Language Servers

| Server | Purpose |
|--------|---------|
| `stylua` | Lua code formatter |
| `eslint` | JavaScript/TypeScript linting |
| `lua_ls` | Lua language server (Neovim config optimized) |
| `markdown_oxide` | Markdown LSP with reference counting |

### LSP Keybindings (on attach)

| Key | Mode | Action |
|-----|------|--------|
| `gr` | n | Rename symbol |
| `ga` | n, x | Code action |
| `gD` | n | Go to declaration |
| `gd` | n | Go to definition |
| `<leader>th` | n | Toggle inlay hints |

### Features
- Document highlight on cursor hold
- Automatic inlay hint toggle support
- Custom Lua LS setup for Neovim config
- Workspace-aware configuration

## Mason Commands

| Command | Description |
|---------|-------------|
| `:Mason` | Open Mason package manager |
| `g?` | Help in Mason menu |

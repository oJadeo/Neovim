---
title: "AI & Copilot"
tags:
  - ai
  - keymap
---

# AI & Copilot

## Overview

GitHub Copilot integration with both inline suggestions and chat interface.

## Plugin: copilot.lua

**File:** `lua/plugins/copilot.lua`

### Configuration
- **Suggestion mode:** Enabled when not using completion
- **Auto-trigger:** Yes
- **Filetypes:** Enabled for markdown and help files

### Inline Suggestion Keys

| Key | Action |
|-----|--------|
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |

## Plugin: blink-cmp-copilot

Provides Copilot as a completion source in blink.cmp with high priority (score_offset: 100).

## Plugin: CopilotChat.nvim

Interactive chat interface with GitHub Copilot.

### Configuration
- **Window width:** 40% of screen
- **Auto-insert mode:** Enabled
- **Headers:** Custom user and Copilot icons

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | i (copilot-chat) | Submit prompt |
| `<leader>a` | n, v | AI commands prefix |
| `<leader>aa` | n, v | Toggle CopilotChat |
| `<leader>ax` | n, v | Clear chat |
| `<leader>aq` | n, v | Quick chat (prompt input) |
| `<leader>ap` | n, v | Prompt actions |

### Commands
- `:Copilot` - Main Copilot command
- `:CopilotChat` - Open chat interface
- `:Copilot auth` - Authenticate with GitHub

## Setup

Run `:Copilot auth` on first use to authenticate with GitHub.

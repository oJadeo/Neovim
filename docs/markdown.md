---
title: "Markdown & Notes"
tags:
  - markdown
  - keymap
---

# Markdown & Notes

## Overview

Markdown editing with Obsidian integration for note-taking and knowledge management.

## Plugin: obsidian.nvim

**File:** `lua/plugins/markdown.lua`

### Features
- Obsidian vault integration
- Note creation and linking
- Template support
- Backlinks management
- Telescope picker integration

### Workspaces

| Name | Path |
|------|------|
| Home | `/mnt/nvme/Obsidian/SecondBrain/` |
| Work | `/mnt/d/Obsidian/SecondBrain/` |

### Templates
- **Folder:** `99-MetaData/Template`

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>onn` | n | New Obsidian note |
| `<leader>ont` | n | New note from template |
| `<leader>oo` | n | Search Obsidian notes |
| `<leader>oc` | n | Table of contents |
| `<leader>ob` | n | Search backlinks |
| `<leader>ol` | n | Search links |
| `<leader>oe` | v | Extract selection to new note |

### Configuration
- Completion via blink.cmp
- UI rendering disabled (handled by render-markdown)
- Legacy commands disabled

## Plugin: render-markdown.nvim

**File:** `lua/plugins/markdown.lua`

### Features
- Beautiful markdown rendering in buffer
- Renders in ALL modes
- Checkbox styling with strikethrough for completed
- Inline code rendering

### Configuration
- **Filetypes:** markdown, codecompanion
- **LSP completions:** Enabled
- **Checked checkbox:** Strikethrough highlight

## LSP Support

- **markdown_oxide** - Provides reference counting and codelens
- Codelens auto-refresh for markdown buffers (see `autocmds.lua`)

## Additional Resources

- [Obsidian](https://obsidian.md) - Knowledge base app
- Custom keymaps in `lua/keymaps/markdown/`

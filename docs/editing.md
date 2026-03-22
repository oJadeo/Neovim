---
title: "Syntax & Editing"
tags:
  - editing
---

# Syntax & Editing

## Overview

Syntax highlighting, text objects, and editing enhancements for improved code manipulation.

## Plugin: nvim-treesitter

**File:** `lua/plugins/treesitter.lua`

### Features
- Advanced syntax highlighting
- Code indentation
- Auto-install parsers

### Installed Parsers

| Parser | Purpose |
|--------|---------|
| gdscript | Godot GDScript |
| godot_resource | Godot resource files |
| gdshader | Godot shaders |
| lua | Lua |
| markdown | Markdown |
| bash | Shell scripts |

### Configuration
- **Auto-install:** Enabled for all filetypes
- **Highlight:** Enabled
- **Indent:** Enabled

## Plugin: mini.nvim

**File:** `lua/plugins/mini.lua`

Collection of minimal, fast modules.

### mini.ai (Around/Inside textobjects)

Enhanced text objects for operations.

| Example | Action |
|---------|--------|
| `va)` | Visual select around paren |
| `yinq` | Yank inside next quote |
| `ci'` | Change inside quote |
| `n_lines: 500` | Search up to 500 lines |

### mini.surround

Add/delete/replace surroundings.

| Example | Action |
|---------|--------|
| `saiw)` | Surround add inner word with paren |
| `sd'` | Surround delete quotes |
| `sr)'` | Surround replace ) with ' |

### mini.statusline

Lightweight statusline.

- Uses Nerd Font icons when available
- Location format: `LINE:COLUMN`

## Plugin: mini.pairs

**File:** `lua/plugins/mini.lua`

Autopair plugin for brackets, quotes, etc.

### Configuration
- **Modes:** insert, command (not terminal)
- **Skip in:** strings (treesitter), when unbalanced
- **Markdown support:** Enabled
- **Disabled mappings:** `` ` `` (backtick)

### Skip Conditions
- Next char is word, %, ', [, ", ., `, $
- Inside string (treesitter)
- More closing than opening pairs

## Plugin: guess-indent.nvim

**File:** `lua/plugins/guess-indent.lua`

Automatically detects and sets indentation style (tabs vs spaces, width) based on file content.

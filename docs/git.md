---
title: "Git Integration"
tags:
  - git
  - keymap
---

# Git Integration

## Overview

Git integration providing visual indicators and utilities for version control.

## Plugin: gitsigns.nvim

**File:** `lua/plugins/gitsigns.lua`

### Features
- Shows git signs in the sign column (gutter)
- Utilities for managing git changes

### Sign Indicators

| Sign | Meaning |
|------|---------|
| `+` | Added line |
| `~` | Modified line |
| `_` | Deleted line |
| `‾` | Top delete |
| `~` | Change delete |

### Available Actions
- Stage/reset hunks
- Preview hunks
- Blame line
- Navigate between changes

### Keybinding Group
- `<leader>h` - Git Hunk commands (n, v)

## Related

See [Debugging & Diagnostics](./debugging.md) for using Trouble with git diagnostics.

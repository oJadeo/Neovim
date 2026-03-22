---
name: update-docs-on-config-change
description: Use when creating, editing, or deleting any plugin file in lua/plugins/ or any config file in lua/ - requires updating corresponding docs/
---

# Update Docs on Config Change

## Overview

**Core principle:** When you touch the config, you touch the docs. Documentation must stay in sync with code.

## When to Use

**TRIGGER:** You are about to commit changes to ANY of these:
- `lua/plugins/*.lua` - Plugin configurations
- `lua/*.lua` - Core config files (vim-options.lua, etc.)
- `lua/keymaps/**/*.lua` - Keybinding definitions
- `lsp/*.lua` - LSP configurations

**DO NOT trigger for:**
- Changes to docs/ itself
- Git-only operations (no file changes)
- Reading without editing

## YAML Front Matter Standard

All markdown files in `docs/` MUST have YAML front matter with title and tags:

```yaml
---
title: "Descriptive Title"
tags:
  - category
  - subcategory
---
```

**Rules:**
- Every doc file needs front matter
- `title` is required - human-readable, quoted
- `tags` is required - use multi-line format (one tag per line with `- ` prefix)
- Tags should be lowercase, single words or kebab-case

**Common tags:** `keymap`, `editing`, `navigation`, `formatting`, `debugging`, `git`, `lsp`, `completion`, `ui`, `utility`, `ai`, `markdown`

## Workflow

```
Config file changed → Check docs/ → Update affected files → Verify cross-references
```

### 1. Identify Changed Files

After editing plugin/config files, determine which docs need updates:

| Changed File | Docs to Update |
|--------------|----------------|
| `lua/plugins/autocomplete.lua` | `docs/autocompletion.md` |
| `lua/plugins/lsp-config.lua` | `docs/lsp.md` |
| `lua/plugins/copilot.lua` | `docs/ai-copilot.md` |
| `lua/plugins/debugging.lua` | `docs/debugging.md` |
| `lua/plugins/gitsigns.lua` | `docs/git.md` |
| `lua/plugins/autoformat.lua` or `none-ls.lua` | `docs/autoformatting.md` |
| `lua/plugins/markdown.lua` | `docs/markdown.md` |
| `lua/plugins/telescope.lua`, `neo-tree.lua`, `yazi.lua`, `alpha.lua` | `docs/navigation.md` |
| `lua/plugins/treesitter.lua`, `mini.lua`, `guess-indent.lua` | `docs/editing.md` |
| `lua/plugins/theme.lua`, `lualine.lua`, `noice.lua`, etc. | `docs/ui.md` |
| `lua/plugins/undotree.lua`, `outline.lua`, `trouble.lua` | `docs/utilities.md` |
| `lua/keymaps/*.lua` | `docs/keymaps.md` |
| `lua/vim-options.lua` | `docs/README.md` (Core Settings section) |
| `lua/keymaps/markdown/filter.lua` | `docs/markdown/filter-system.md` |
| `lua/keymaps/markdown/folding.lua` | `docs/markdown/folding-system.md` |
| `lua/keymaps/markdown/navigate.lua` | `docs/markdown/navigation-system.md` |
| `lua/keymaps/markdown/spell.lua` | `docs/markdown/spell-system.md` |
| `lua/keymaps/markdown/style_text.lua` | `docs/markdown/text-styling.md` |
| `lua/util/helpers.lua` | `docs/markdown/helpers.md` |
| `lua/godot.lua` or `lsp/gdscript.lua` | `docs/markdown/godot-integration.md` |

### 2. Update Keymaps.md

If keybindings changed:
1. Find the relevant section in `docs/keymaps.md`
2. Update the table with new/changed/removed keybindings
3. Include Mode column (n, v, i, t, x)

### 3. Update Plugin Docs

For plugin changes:
1. Open the corresponding `docs/*.md` file
2. Ensure front matter exists with title and tags (see YAML Front Matter Standard)
3. Update configuration details
4. Add/remove/update keybinding tables
5. Update feature lists if behavior changed

### 4. Update Code Documentation

For custom Lua modules (`lua/keymaps/markdown/`, `lua/util/`):
1. Update the corresponding `docs/markdown/*.md` file
2. Update code examples if logic changed
3. Add new functions/sections if new code added

### 5. Update README.md (if needed)

For major changes:
- Update plugin count
- Add new plugin categories
- Update Core Settings if vim-options.lua changed

## Red Flags - STOP and Update Docs

- You edited a plugin file and haven't opened docs/
- You added a new keybinding and keymaps.md wasn't touched
- You changed how a feature works and the explanation is stale
- You're about to commit config changes without docs changes
- New doc file created without front matter (title + tags)

## Quick Reference

```
Plugin changed → docs/[category].md
Keymap changed → docs/keymaps.md  
Custom code changed → docs/markdown/[system].md
Settings changed → docs/README.md
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgot to update keymaps.md | Always check keymaps.md after keymap changes |
| Updated plugin but not docs | Open both files side-by-side before committing |
| Docs show old default value | Re-read plugin config, update docs to match |
| New keybinding missing from docs | Add to relevant section with mode and description |

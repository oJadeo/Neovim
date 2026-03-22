---
title: "Autocompletion & Snippets"
tags:
  - completion
---

# Autocompletion & Snippets

## Overview

Fast autocompletion using blink.cmp with LuaSnip for snippet support and Copilot integration.

## Plugin: blink.cmp

**File:** `lua/plugins/autocomplete.lua`

### Configuration
- **Keymap preset:** `super-tab` (Tab to navigate/accept)
- **Documentation:** Auto-show after 500ms delay
- **Signature help:** Enabled (shows function signatures while typing)

### Sources (priority order)
1. `lsp` - Language server completions
2. `path` - File path completions
3. `snippets` - Snippet expansions
4. `buffer` - Current buffer words
5. `copilot` - AI suggestions (score_offset: 100)

## Plugin: LuaSnip

**Dependency of blink.cmp**

### Features
- Snippet engine for Neovim
- Regex support in snippets (via `install_jsregexp`)
- VSCode-style snippet loading

### Plugin: friendly-snippets
Pre-made snippets for various languages and frameworks.

## Keybindings (super-tab preset)

| Key | Action |
|-----|--------|
| `Tab` | Select next item / accept |
| `S-Tab` | Select previous item |
| `Enter` | Accept selected item (when menu open) |
| `<C-Space>` | Toggle completion menu |
| `<C-e>` | Hide completion menu |

### Documentation Window

Documentation auto-shows after 500ms when hovering over a completion item (configured via `documentation = { auto_show = true }`).

## Copilot Integration

See [AI & Copilot](./ai-copilot.md) for Copilot completion setup.

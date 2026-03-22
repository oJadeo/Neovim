---
title: "Keymaps Reference"
tags:
  - keymap
  - reference
---

# Keymaps Reference

Complete keybinding reference for this Neovim configuration.

## Leader Key

**Leader:** `Space`

---

## General & Utility

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | n | Clear search highlights |
| `<leader>q` | n | Open diagnostic quickfix list |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<leader>u` | n | Toggle undotree |

## Window Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | n | Move focus to left window |
| `<C-l>` | n | Move focus to right window |
| `<C-j>` | n | Move focus to lower window |
| `<C-k>` | n | Move focus to upper window |
| `<C-S-h>` | n | Move window to left |
| `<C-S-l>` | n | Move window to right |
| `<C-S-j>` | n | Move window to lower |
| `<C-S-k>` | n | Move window to upper |

---

## LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Rename symbol |
| `ga` | n, x | Code action |
| `grr` | n | Go to references (Telescope) |
| `gri` | n | Go to implementation (Telescope) |
| `grd` | n | Go to definition (Telescope) |
| `grt` | n | Go to type definition (Telescope) |
| `gO` | n | Document symbols (Telescope) |
| `gW` | n | Workspace symbols (Telescope) |
| `<leader>th` | n | Toggle inlay hints |

---

## Telescope Search

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sh` | n | Search help tags |
| `<leader>sk` | n | Search keymaps |
| `<leader>sf` | n | Search files |
| `<leader>ss` | n | Search Telescope builtins |
| `<leader>sw` | n, v | Search current word |
| `<leader>sg` | n | Live grep |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sr` | n | Resume last search |
| `<leader>s.` | n | Search recent files |
| `<leader>sc` | n | Search commands |
| `<leader><leader>` | n | Find existing buffers |
| `<leader>/` | n | Fuzzy search in current buffer |
| `<leader>s/` | n | Grep in open files |
| `<leader>sn` | n | Search Neovim config files |

---

## File Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | n | Toggle Neo-tree (reveal file) |
| `<leader>ee` | n, v | Open yazi at current file |
| `<leader>ec` | n | Open yazi in working directory |
| `<leader>et` | n | Resume last yazi session |

---

## Formatting

| Key | Mode | Action |
|-----|------|--------|
| `<leader>f` | n, v, x | Format buffer (conform.nvim) |
| `<leader>gf` | n | LSP format (none-ls) |

---

## AI & Copilot

| Key | Mode | Action |
|-----|------|--------|
| `<M-]>` | n | Next Copilot suggestion |
| `<M-[>` | n | Previous Copilot suggestion |
| `<C-s>` | i (chat) | Submit prompt |
| `<leader>a` | n, v | AI commands prefix |
| `<leader>aa` | n, v | Toggle CopilotChat |
| `<leader>ax` | n, v | Clear CopilotChat |
| `<leader>aq` | n, v | Quick chat |
| `<leader>ap` | n, v | Prompt actions |

---

## Obsidian

| Key | Mode | Action |
|-----|------|--------|
| `<leader>onn` | n | New Obsidian note |
| `<leader>ont` | n | New note from template |
| `<leader>oo` | n | Search Obsidian notes |
| `<leader>oc` | n | Table of contents |
| `<leader>ob` | n | Search backlinks |
| `<leader>ol` | n | Search links |
| `<leader>oe` | v | Extract to new note |

---

## Markdown - Navigation

| Key | Mode | Action |
|-----|------|--------|
| `gk` | n, v | Go to previous heading |
| `gj` | n, v | Go to next heading |

---

## Markdown - Folding

| Key | Mode | Action |
|-----|------|--------|
| `zj` | n | Fold all headings (level 1+) |
| `zk` | n | Fold headings level 2+ |
| `zl` | n | Fold headings level 3+ |
| `z;` | n | Fold headings level 4+ |
| `zu` | n | Unfold all headings |
| `zi` | n | Fold current heading |

---

## Markdown - Spelling

| Key | Mode | Action |
|-----|------|--------|
| `<leader>msle` | n | Set spell language to English |
| `<leader>mss` | n | Accept first spelling suggestion |
| `<leader>msa` | n | Add word to spellfile |
| `<leader>msu` | n | Remove word from spellfile |
| `<leader>msr` | n | Repeat spelling replacement |

---

## Markdown - Text Styling

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mb` | n | Toggle bold (word/selection) |
| `<leader>mb` | v | Bold selection |
| `<leader>ms` | v | Strikethrough selection |
| `<leader>md` | n | Toggle bullet/dash |
| `<leader>mc` | n, i | Create checkbox/task |
| `<leader>mx` | n | Toggle task completion (with timestamp) |
| `<leader>mj` | v | Delete blank lines in selection |

---

## Markdown - Filter

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mf` | n | Open markdown content filter |

### Filter Syntax
- `#tag` - Filter by tag
- `@project` - Filter by project
- `word` - Filter by path/title

---

## Debugging

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dt` | n | Toggle breakpoint |
| `<leader>dc` | n | Continue/start debugging |

---

## Diagnostics (Trouble)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | n | Toggle trouble list |
| `[t` | n | Next trouble item |
| `]t` | n | Previous trouble item |

---

## UI & Zen Mode

| Key | Mode | Action |
|-----|------|--------|
| `<leader>zz` | n | Zen mode (90 width, numbers on) |
| `<leader>zZ` | n | Zen mode (80 width, minimal) |
| `<leader>to` | n | Toggle outline |

---

## Git

| Key | Mode | Action |
|-----|------|--------|
| `<leader>h` | n, v | Git hunk commands prefix |

---

## Godot (in Godot projects only)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>b` | n | Insert breakpoint |
| `<leader>BD` | n | Delete all breakpoints in file |
| `<leader>BF` | n | Find all breakpoints in project |

---

## Mini.nvim Text Objects

| Example | Action |
|---------|--------|
| `va)` | Visual select around paren |
| `yinq` | Yank inside next quote |
| `ci'` | Change inside quote |

## Mini.nvim Surround

| Example | Action |
|---------|--------|
| `saiw)` | Surround add inner word with paren |
| `sd'` | Surround delete quotes |
| `sr)'` | Surround replace ) with ' |

---

## Which-Key Groups

| Prefix | Description |
|--------|-------------|
| `<leader>s` | Search |
| `<leader>t` | Toggle / Todo |
| `<leader>h` | Git Hunk |
| `<leader>o` | Obsidian |
| `<leader>m` | Markdown |
| `<leader>e` | Yazi |
| `<leader>a` | AI/Copilot |
| `<leader>ms` | Markdown Spelling |
| `<leader>msl` | Markdown Spelling Language |
| `<leader>mf` | Markdown Fold |

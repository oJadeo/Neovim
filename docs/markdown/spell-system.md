---
title: "Spelling System"
tags:
  - markdown
  - keymap
---

# Spelling System

**File:** `lua/keymaps/markdown/spell.lua`

Multi-language spelling support with custom keybindings for managing the spellfile.

---

## Overview

Provides keybindings to:
- Switch spelling language
- Accept spelling suggestions
- Add/remove words from the spellfile
- Repeat spelling replacements

---

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>msle` | n | Set language to English |
| `<leader>mss` | n | Accept first suggestion |
| `<leader>msa` | n | Add word to spellfile |
| `<leader>msu` | n | Remove word from spellfile |
| `<leader>msr` | n | Repeat last replacement |

---

## Switch Language

```lua
vim.keymap.set("n", "<leader>msle", function()
    vim.opt.spelllang = "en"
    vim.cmd("echo 'Spell language set to English'")
end, { desc = "Spelling language English" })
```

### Add More Languages

```lua
vim.keymap.set("n", "<leader>msls", function()
    vim.opt.spelllang = "es"
    vim.cmd("echo 'Spell language set to Spanish'")
end, { desc = "Spelling language Spanish" })

vim.keymap.set("n", "<leader>mslg", function()
    vim.opt.spelllang = "de"
    vim.cmd("echo 'Spell language set to German'")
end, { desc = "Spelling language German" })

-- Multiple languages at once
vim.keymap.set("n", "<leader>mslm", function()
    vim.opt.spelllang = { "en", "es", "de" }
    vim.cmd("echo 'Spell language: English, Spanish, German'")
end, { desc = "Spelling language Multi" })
```

---

## Accept First Suggestion

```lua
vim.keymap.set("n", "<leader>mss", function()
    vim.cmd("normal! 1z=")
end, { desc = "Accept first spelling suggestion" })
```

### How `1z=` Works

- `z=` - Open spelling suggestions
- `1` - Automatically select the first suggestion

This skips the suggestion menu and applies the top suggestion immediately.

### See All Suggestions

Use `z=` directly (no keybinding needed) to see the full list.

---

## Add Word to Spellfile

```lua
vim.keymap.set("n", "<leader>msa", function()
    vim.cmd("normal! zg")
    vim.cmd("silent write")
end, { desc = "Add word to spellfile" })
```

### How `zg` Works

- `zg` - Add word under cursor to spellfile as "good"
- Creates/updates `spell/*.utf-8.add` file
- Future occurrences won't be marked as misspelled

### Why Write After Adding?

```lua
vim.cmd("silent write")
```

Writing updates external tools like Harper (grammar checker) that may read the spellfile.

---

## Remove Word from Spellfile

```lua
vim.keymap.set("n", "<leader>msu", function()
    vim.cmd("normal! zug")
end, { desc = "Remove word from spellfile" })
```

### How `zug` Works

- `zu` - Undo
- `zg` - Good word command
- `zug` - Undo the "good word" marking, removing it from the spellfile

---

## Repeat Replacement

```lua
vim.keymap.set("n", "<leader>msr", function()
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(":spellr\n", true, false, true),
        "m", 
        true
    )
end, { desc = "Repeat spelling replacement" })
```

### How `:spellr` Works

After using `z=` to correct a word, `:spellr` repeats that same correction for all other occurrences of the misspelled word in the current window.

### Why `nvim_feedkeys`?

`:spellr` is a command, not a normal mode key, so we need to:
1. `nvim_replace_termcodes` - Convert `:spellr\n` to proper keycodes
2. `nvim_feedkeys` - Simulate typing the command

---

## Spellfile Location

Spellfiles are stored in:
```
~/.config/nvim/spell/en.utf-8.add
```

### Configuration (in vim-options.lua)

Spell is enabled via autocommand for text files:

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
```

---

## Persistence

To persist spellfile changes across sessions, add to your session options:

```lua
vim.opt.sessionoptions:append("localoptions")
```

This saves `spelllang` and other buffer-local settings.

---

## Vim Spelling Commands Reference

| Command | Action |
|---------|--------|
| `]s` | Jump to next misspelled word |
| `[s` | Jump to previous misspelled word |
| `z=` | Show suggestions for word under cursor |
| `zg` | Mark word as good (add to spellfile) |
| `zw` | Mark word as wrong |
| `zug` | Undo `zg` (remove from spellfile) |
| `zuw` | Undo `zw` |
| `:spellr` | Repeat last replacement |
| `:set spell` | Enable spell checking |
| `:set nospell` | Disable spell checking |
| `:set spelllang=en` | Set language |

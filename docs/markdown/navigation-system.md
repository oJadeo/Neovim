---
title: "Markdown Navigation System"
tags:
  - markdown
  - navigation
  - keymap
---

# Markdown Navigation System

**File:** `lua/keymaps/markdown/navigate.lua`

Jump between markdown/typst headings with simple keybindings.

---

## Overview

Provides heading navigation that searches up or down for the next markdown heading (H2 and above).

---

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `gk` | n, v | Go to previous heading |
| `gj` | n, v | Go to next heading |

---

## How It Works

### Previous Heading (`gk`)

```lua
vim.keymap.set({ "n", "v" }, "gk", function()
    local ft = vim.bo.filetype
    if ft == "typst" then
        vim.cmd("silent! ?^==\\+\\s.*$")
    else
        vim.cmd("silent! ?^##\\+\\s.*$")
    end
    vim.cmd("nohlsearch")
end, { desc = "Go to previous markdown header" })
```

### Next Heading (`gj`)

```lua
vim.keymap.set({ "n", "v" }, "gj", function()
    local ft = vim.bo.filetype
    if ft == "typst" then
        vim.cmd("silent! /^==\\+\\s.*$")
    else
        vim.cmd("silent! /^##\\+\\s.*$")
    end
    vim.cmd("nohlsearch")
end, { desc = "Go to next markdown header" })
```

---

## Regex Pattern Explanation

### Markdown Pattern

```
/^##\\+\\s.*$
```

| Part | Meaning |
|------|---------|
| `/` | Search forward (`?` for backward) |
| `^` | Start of line |
| `##` | Match exactly two `#` characters |
| `\\+` | One or more of previous character (so 2+ `#` symbols) |
| `\\s` | Exactly one whitespace character |
| `.*` | Any characters (the heading text) |
| `$` | End of line |

**Matches:** `## Heading`, `### Heading`, `#### Heading`, etc.

**Does NOT match:** `# Heading` (H1 - single `#`)

### Typst Pattern

```
/^==\\+\\s.*$
```

Same logic but with `=` instead of `#`.

**Matches:** `== Heading`, `=== Heading`, etc.

---

## Why H2 and Above?

The regex requires at least 2 `#` symbols (`##\\+`), which means:
- H1 (`#`) is skipped
- H2-H6 (`##` to `######`) are matched

This follows the convention that:
1. Documents have a single H1 at the top
2. Content navigation should skip the title
3. Users want to jump between sections, not back to the title

---

## Silent Search

The `silent!` prefix suppresses error messages when:
- No heading exists in that direction
- At the first/last heading

---

## Clear Highlights

After navigation, `vim.cmd("nohlsearch")` clears the search highlight so you don't see the pattern highlighted.

---

## Mode Support

Works in both:
- **Normal mode** (`n`) - Jump while editing
- **Visual mode** (`v`) - Extend selection to next heading

---

## Integration with Fold System

These keybindings work well with the folding system:

| Workflow | Keys |
|----------|------|
| Navigate to heading | `gj` / `gk` |
| Fold current heading | `zi` |
| Fold all | `zj` |

---

## Customization

### Include H1 Headings

Change the regex to match single `#`:

```lua
vim.cmd("silent! ?^#\\+\\s.*$")  -- Matches H1-H6
```

### Different Keybindings

```lua
vim.keymap.set({ "n", "v" }, "[h", function() ... end)  -- Previous
vim.keymap.set({ "n", "v" }, "]h", function() ... end)  -- Next
```

### Limit to Specific Levels

```lua
-- Only H2 headings
vim.cmd("silent! ?^##\\s.*$")

-- Only H3 headings  
vim.cmd("silent! ?^###\\s.*$")
```

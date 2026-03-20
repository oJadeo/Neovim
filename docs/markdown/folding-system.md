---
title: "Markdown Folding System"
tags:
  - markdown
  - keymap
---

# Markdown Folding System

**File:** `lua/keymaps/markdown/folding.lua`

Treesitter-based folding for markdown and typst files with level-specific keybindings.

---

## Overview

Custom folding system that:
- Uses Treesitter to parse markdown headings
- Handles frontmatter (YAML between `---` markers)
- Provides keybindings to fold by heading level
- Supports both Markdown and Typst files

---

## Fold Keybindings

| Key | Action | Folds |
|-----|--------|-------|
| `zj` | Fold all headings | Level 1-6 (entire document) |
| `zk` | Fold headings | Level 2-6 (keeps H1 visible) |
| `zl` | Fold headings | Level 3-6 (keeps H1-H2 visible) |
| `z;` | Fold headings | Level 4-6 (keeps H1-H3 visible) |
| `zu` | Unfold all | Opens everything |
| `zi` | Fold current | Folds heading under cursor |

---

## How It Works

### Fold Expression (`markdown_foldexpr`)

```lua
function _G.markdown_foldexpr()
    local lnum = vim.v.lnum
    local line = vim.fn.getline(lnum)
    local heading = line:match("^(#+)%s")
    if heading then
        local level = #heading  -- Count number of # characters
        if level == 1 then
            -- Special handling for H1 (check frontmatter)
            if lnum == 1 then return ">1" end
            local frontmatter_end = vim.b.frontmatter_end
            if frontmatter_end and (lnum == frontmatter_end + 1) then
                return ">1"
            end
        elseif level >= 2 and level <= 6 then
            return ">" .. level
        end
    end
    return "="  -- Inherit from previous line
end
```

**Return values:**
- `>N` - Start a fold at level N
- `=` - Inherit fold level from previous line

### Frontmatter Detection

H1 headings get special treatment when they appear after YAML frontmatter:

```lua
local function set_markdown_folding()
    -- ...fold setup...
    
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local found_first = false
    local frontmatter_end = nil
    for i, line in ipairs(lines) do
        if line == "---" then
            if not found_first then
                found_first = true
            else
                frontmatter_end = i
                break
            end
        end
    end
    vim.b.frontmatter_end = frontmatter_end
end
```

This ensures the first H1 after frontmatter starts a new fold section.

### Typst Support

Typst uses `=` instead of `#` for headings:

```lua
function _G.typst_foldexpr()
    local line = vim.fn.getline(vim.v.lnum)
    local heading = line:match("^(=+)%s")  -- Match = symbols
    if heading then
        local level = #heading
        return ">" .. level
    end
    return "="
end
```

---

## Folding Functions

### `fold_headings_of_level(level)`

Folds all headings at a specific level:

```lua
local function fold_headings_of_level(level)
    vim.cmd("keepjumps normal! gg")  -- Go to top without adding to jumplist
    local total_lines = vim.fn.line("$")
    
    for line = 1, total_lines do
        local line_content = vim.fn.getline(line)
        -- Match heading pattern: "^#{level} "
        if line_content:match("^" .. string.rep("#", level) .. "%s") then
            vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
            local current_foldlevel = vim.fn.foldlevel(line)
            if current_foldlevel > 0 and vim.fn.foldclosed(line) == -1 then
                vim.cmd("normal! za")  -- Toggle fold open/closed
            end
        end
    end
end
```

**Key points:**
- `keepjumps` - Doesn't pollute the jumplist
- `foldclosed(line) == -1` - Only fold if currently open
- `za` - Toggle fold

### `fold_markdown_headings(levels)`

Folds multiple levels while preserving cursor position:

```lua
local function fold_markdown_headings(levels)
    local saved_view = vim.fn.winsaveview()  -- Save scroll position
    for _, level in ipairs(levels) do
        fold_headings_of_level(level)
    end
    vim.cmd("nohlsearch")
    vim.fn.winrestview(saved_view)  -- Restore position
end
```

---

## Keybinding Implementation

Example for `zj` (fold all):

```lua
vim.keymap.set("n", "zj", function()
    vim.cmd("silent update")           -- Save if modified
    vim.cmd("edit!")                    -- Reload file to refresh folds
    vim.cmd("normal! zR")               -- Unfold everything first
    fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })  -- Fold from deepest to shallowest
    vim.cmd("normal! zz")               -- Center cursor on screen
end, { desc = "Fold all headings level 1 or above" })
```

**Why fold from deepest to shallowest?**
Folding `6, 5, 4, 3, 2, 1` ensures inner sections fold before outer sections, preventing issues with nested folds.

---

## Autocommands

Folding is automatically enabled for markdown and typst files:

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = set_markdown_folding,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = set_typst_folding,
})
```

---

## Heading Navigation Helper

`get_markdown_headings()` uses Treesitter to find all headings:

```lua
local function get_markdown_headings()
    local parser = vim.treesitter.get_parser(0, "markdown")
    local tree = parser:parse()[1]
    local query = vim.treesitter.query.parse("markdown", [[
        (atx_heading (atx_h1_marker) @h1)
        (atx_heading (atx_h2_marker) @h2)
        (atx_heading (atx_h3_marker) @h3)
        (atx_heading (atx_h4_marker) @h4)
        (atx_heading (atx_h5_marker) @h5)
        (atx_heading (atx_h6_marker) @h6)
    ]])
    
    local headings = {}
    for id, node in query:iter_captures(tree:root(), 0) do
        local start_line = node:start() + 1
        table.insert(headings, { line = start_line, level = id })
    end
    -- Returns: current line, current level, next heading, next level, 
    --          next same-level line, next same-level level
end
```

---

## Customization

### Change Default Fold Level

```lua
vim.opt_local.foldlevel = 99  -- Start with all folds open (0 = all closed)
```

### Add More Fold Levels

Create new keybinding:

```lua
vim.keymap.set("n", "zh", function()
    vim.cmd("silent update")
    vim.cmd("edit!")
    vim.cmd("normal! zR")
    fold_markdown_headings({ 6, 5 })  -- Only fold H5 and H6
    vim.cmd("normal! zz")
end, { desc = "Fold deep headings only" })
```

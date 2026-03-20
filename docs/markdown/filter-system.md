---
title: "Markdown Content Filter System"
tags:
  - markdown
  - navigation
  - keymap
---

# Markdown Content Filter System

**File:** `lua/keymaps/markdown/filter.lua`

A custom Telescope picker for searching and filtering markdown content by tags, projects, and path.

---

## Overview

This module creates a Telescope picker that parses markdown frontmatter and enables fuzzy filtering by multiple criteria simultaneously.

---

## Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mf` | n | Open markdown content filter |
| `<leader>mt` | n | Filter by tags (multi-select) |

---

## Filter Syntax

When the picker opens, type your search using these prefixes:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `#` | Filter by tag | `#programming #lua` |
| `@` | Filter by project | `@website @tool` |
| (no prefix) | Filter by path/title | `neovim config` |

**Example query:** `#tutorial @website neovim setup`

This finds notes tagged with "tutorial" in the "website" project containing "neovim setup" in the path.

---

## Filter by Tags (`<leader>mt`)

**File:** `lua/keymaps/markdown/filter_tags.lua`

Two-stage tag picker for filtering markdown files by their frontmatter tags.

### How It Works

1. **Extract tags** - Scans all markdown files for `tags:` in frontmatter
2. **Tag picker** - Multi-select tags with `<Tab>`, confirm with `<Enter>`
3. **File picker** - Shows files matching ALL selected tags (AND logic)

### Supported Tag Formats

```yaml
tags: [tag1, tag2, tag3]
```

```yaml
tags:
  - tag1
  - tag2
```

### Example Workflow

1. Press `<leader>mt`
2. See list of all tags with file counts
3. Press `<Tab>` to select multiple tags (e.g., `keymap`, `markdown`)
4. Press `<Enter>` to see files with BOTH tags
5. Select a file and press `<Enter>` to open it
6. Press `<Esc>` in file picker to go back and modify tag selection (previous tags remembered)

---

## How It Works

### 1. Content Parsing (`list_markup_content`)

```lua
local output = vim.fn.system("rg -NoHU --heading '(?s)\\A---\\w*\\n(.*?)\\n---'")
```

Uses ripgrep to find all files with YAML frontmatter (content between `---` markers).

### 2. Prompt Parsing (`split_prompt`)

```lua
local function split_prompt(prompt)
    local tags = {}
    local project = {}
    local path = {}
    for word in prompt:gmatch("([^%s]+)") do
        local fst = word:sub(1, 1)
        if fst == "#" then
            table.insert(tags, word:sub(2))
        elseif fst == "@" then
            table.insert(project, word:sub(2))
        else
            table.insert(path, word)
        end
    end
    return { tags = tags, project = project, path = path }
end
```

Splits the search prompt into three categories:
- **tags** - Words starting with `#`
- **project** - Words starting with `@`
- **path** - All other words

### 3. Scoring System (`content_sorter`)

Custom sorter that scores entries based on multiple factors:

#### Fuzzy Matching Score
Each filter type gets an independent fuzzy match score using fzy algorithm:

```lua
local project_score = score_element(prompt.project, entry.project, fzy_sorter)
local tags_score = score_element(prompt.tags, entry.tags, fzy_sorter)
local path_score = score_element(prompt.path, entry.path, fzy_sorter)
```

If any filter type matches negatively (`-1`), the entry is filtered out.

#### Item Type Score
Different content types get different base scores:

| Type | Score |
|------|-------|
| Knowledge | 0.1 |
| Analysis | 0.11 |
| Note | 0.12 |

```lua
local function score_item_type(item)
    if item.type == "Knowledge" then return 0.1
    elseif item.type == "Analysis" then return 0.11
    elseif item.type == "Note" then return 0.12
    else return 0 end
end
```

#### Date Score
Newer content ranks higher (recency boost):

```lua
local function score_date(entry)
    -- Calculates 0..1 based on date range from 2009-06-21 to today
    return 1 - (entry_date - beginning_of_time) / (today - beginning_of_time)
end
```

#### Final Score Calculation

```lua
return project_score + tags_score + path_score + date_score / 10 + type_score
```

Date is weighted at 1/10 to prioritize content relevance over recency.

---

## Display Formatting

Different content types show different icons:

| Type | Icon |
|------|------|
| Knowledge | 󱛉 |
| Analysis |  |
| Note | 󱞁 |
| Unknown |  |

---

## Frontmatter Format Expected

The parser expects YAML frontmatter with these fields:

```yaml
---
type: Knowledge
tags: [programming, lua]
project: website
created: 2024-01-15
---
```

### Multi-value Fields

Arrays can be written as:
```yaml
tags: [tag1, tag2, tag3]
```

Or as lists:
```yaml
tags:
  - tag1
  - tag2
```

---

## Dependencies

- **telescope.nvim** - Picker framework
- **nvim-nio** - Async operations
- **ripgrep (rg)** - Content search
- **util.helpers** - Utility functions

---

## Customization

### Change the Search Command

Modify `list_markup_content` to use a different search tool:

```lua
local function list_markup_content(cb)
    local output = vim.fn.system("your-custom-command")
    if output then
        local posts = format_data(output)
        cb(posts)
    end
end
```

### Adjust Scoring Weights

Change the final score calculation in `content_sorter`:

```lua
-- Make date more important
return project_score + tags_score + path_score + date_score / 2 + type_score

-- Make type more important
return project_score + tags_score + path_score + date_score / 10 + type_score * 2
```

### Add New Item Types

Extend `score_item_type`:

```lua
local function score_item_type(item)
    if item.type == "Knowledge" then return 0.1
    elseif item.type == "Analysis" then return 0.11
    elseif item.type == "Note" then return 0.12
    elseif item.type == "Tutorial" then return 0.13  -- New type
    else return 0 end
end
```

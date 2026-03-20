---
title: "Text Styling System"
tags:
  - markdown
  - editing
  - keymap
---

# Text Styling System

**File:** `lua/keymaps/markdown/style_text.lua`

Markdown text formatting including bold, strikethrough, bullets, checkboxes, and task management with completion tracking.

---

## Overview

Provides keybindings for:
- Bold text toggle
- Strikethrough
- Bullet/dash toggle
- Checkbox/task creation
- Task completion with timestamp tracking

---

## Bold

### Visual Mode - Bold Selection

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mb` | v | Bold selected text |

```lua
vim.keymap.set("v", "<leader>mb", function()
    local selected_text = -- get selection
    if selected_text:match("^%*%*.*%*%*$") then
        vim.notify("Text already bold")
    else
        vim.cmd("normal 2gsa*")  -- Add ** surrounding
    end
end)
```

Uses mini.surround: `gsa*` adds asterisks, `2` means 2 characters (`**`).

### Normal Mode - Toggle Bold

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mb` | n | Toggle bold on word/under cursor |

```lua
vim.keymap.set("n", "<leader>mb", function()
    -- 1. Check if cursor is on asterisk
    -- 2. Search for ** markers around cursor
    -- 3. If found: remove them (unbold)
    -- 4. If not found: bold the word
end)
```

**Features:**
- Unbolds if cursor is inside bold text
- Bolds the word under cursor if not in bold
- Handles multi-line bold text

---

## Strikethrough

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ms` | v | Strikethrough selection |

```lua
vim.keymap.set("v", "<leader>ms", function()
    local selected_text = -- get selection
    if selected_text:match("^%~%~.*%~%~$") then
        vim.notify("Text already has strikethrough")
    else
        vim.cmd("normal 2gsa~")  -- Add ~~ surrounding
    end
end)
```

Markdown strikethrough: `~~text~~`

---

## Bullet/Dash Toggle

| Key | Mode | Action |
|-----|------|--------|
| `<leader>md` | n | Toggle bullet point |

```lua
vim.keymap.set("n", "<leader>md", function()
    local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
    
    if line:match("^%s*%-") then
        -- Remove bullet
        line = line:gsub("^%s*%-", "")
        vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
    else
        -- Add bullet to current paragraph
        local new_text = "- " .. text
        -- Handle multi-line paragraphs
    end
end)
```

**Behavior:**
- If line starts with `-`, removes it
- Otherwise, adds `- ` at the start of the current paragraph

---

## Checkbox/Task Creation

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mc` | n, i | Create checkbox |

```lua
vim.keymap.set({ "n", "i" }, "<leader>mc", function()
    local line = vim.api.nvim_get_current_line()
    
    if line:match("^%s*$") then
        -- Empty line: create "- [ ] "
        vim.api.nvim_set_current_line("- [ ] ")
        vim.api.nvim_win_set_cursor(0, { row, 6 })  -- Cursor after brackets
    elseif line:match("^([%s]*[-*]%s+)(.*)$") then
        -- Has bullet: convert to "- [ ] task"
        local bullet, text = line:match("^([%s]*[-*]%s+)(.*)$")
        vim.api.nvim_set_current_line(bullet .. "[ ] " .. text)
    else
        -- Plain text: prepend "- [ ] "
        vim.api.nvim_set_current_line("- [ ] " .. line)
    end
end)
```

**Works with:**
- Empty lines
- Existing bullet points
- Plain text lines

**In insert mode:** Creates checkbox and places cursor inside for immediate typing.

---

## Task Completion System

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mx` | n | Toggle task completion |

### How It Works

The task system tracks completion with labels:

```
- [ ] Task item `untoggled`
- [x] Completed task `done: 240320-1430`
```

### States

1. **New task** (no label): Completes and moves to "## Completed Tasks" section
2. **Untoggled** (`untoggled` label): Marks as done with timestamp
3. **Done** (`done: TIMESTAMP` label): Reverts to untoggled

### Configuration

```lua
local label_done = "done:"           -- Completion label prefix
local timestamp = os.date("%y%m%d-%H%M")  -- e.g., "240320-1430"
local tasks_heading = "## Completed Tasks"  -- Destination heading
```

### Algorithm

```lua
vim.keymap.set("n", "<leader>mx", function()
    -- 1. Find the task bullet (may include multi-line description)
    -- 2. Check current state (untoggled/done/none)
    -- 3. State transition:
    --    none -> done + move to Completed Tasks section
    --    untoggled -> done with timestamp
    --    done -> untoggled
    -- 4. Update checkboxes: [ ] <-> [x]
    -- 5. Save view (preserve folds), update, restore view
end)
```

### Features

- **Multi-line tasks:** Handles task items with descriptions spanning multiple lines
- **Section management:** Creates "## Completed Tasks" if it doesn't exist
- **Fold preservation:** Uses `mkview`/`loadview` to keep folds intact
- **Auto-save:** Writes changes after completion

---

## Join Lines (Remove Blank Lines)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mj` | v | Delete blank lines in selection |

```lua
vim.keymap.set("v", "<leader>mj", ":g/^\\s*$/d<CR>:nohlsearch<CR>")
```

Removes all blank lines from the selected text range.

---

## Mini.surround Integration

The bold and strikethrough commands use mini.surround:

| Command | Surround |
|---------|----------|
| `gsa*` | Add `*` around |
| `2gsa*` | Add `**` around |
| `gsa~` | Add `~` around |
| `2gsa~` | Add `~~` around |
| `gsd*` | Delete `*` surrounding |
| `gsr)*` | Replace `)` with `*` |

---

## Customization

### Change Timestamp Format

```lua
local timestamp = os.date("%Y-%m-%d")  -- "2024-03-20"
local timestamp = os.date("%y%m%d")    -- "240320"
local timestamp = os.date("%H:%M")     -- "14:30"
```

### Change Completed Tasks Heading

```lua
local tasks_heading = "## Done"  -- Custom heading name
local tasks_heading = "### Archive"  -- Different level
```

### Disable Auto-move to Completed Section

Remove the section movement logic from `<leader>mx` to just toggle without moving.

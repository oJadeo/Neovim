---
title: "Godot Integration"
tags:
  - debugging
  - lsp
  - keymap
---

# Godot Integration

**Files:** 
- `lua/godot.lua` - Main integration
- `lsp/gdscript.lua` - LSP configuration

GDScript development support with debugging, breakpoints, and Godot editor communication.

---

## Overview

When opening a Godot project (directory containing `project.godot`), this module:
- Starts a Neovim server for Godot editor communication
- Provides breakpoint management commands
- Configures DAP for debugging

---

## Automatic Project Detection

```lua
local paths_to_check = {'/', '/../'}
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

for key, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
        is_godot_project = true
        godot_project_path = cwd .. value
        break
    end
end
```

Checks for `project.godot` in:
- Current directory (`/`)
- Parent directory (`/../`)

---

## Neovim Server

```lua
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
if is_godot_project and not is_server_running then
    vim.fn.serverstart(godot_project_path .. '/server.pipe')
end
```

### Purpose

Creates a named pipe at `project_path/server.pipe` that allows:
- Godot editor to open files in Neovim
- External Godot plugins to communicate with Neovim

### Godot Editor Setup

In Godot: **Editor → Editor Settings → General → Editor → External Editor**

Set to use Neovim with the server pipe.

---

## Breakpoint Commands

### Insert Breakpoint

| Key | Command | Action |
|-----|---------|--------|
| `<leader>b` | `:GodotBreakpoint` | Insert `breakpoint` on new line |

```lua
vim.api.nvim_create_user_command('GodotBreakpoint', function()
    vim.cmd('normal! obreakpoint')
    vim.cmd('write')
end, {})
```

### Delete All Breakpoints in File

| Key | Command | Action |
|-----|---------|--------|
| `<leader>BD` | `:GodotDeleteBreakpoints` | Remove all `breakpoint` lines |

```lua
vim.api.nvim_create_user_command('GodotDeleteBreakpoints', function()
    vim.cmd('g/breakpoint/d')
end, {})
```

Uses `:g/pattern/d` to delete all lines matching "breakpoint".

### Find All Breakpoints in Project

| Key | Command | Action |
|-----|---------|--------|
| `<leader>BF` | `:GodotFindBreakpoints` | Grep for all breakpoints |

```lua
vim.api.nvim_create_user_command('GodotFindBreakpoints', function()
    vim.cmd(':grep breakpoint | copen')
end, {})
```

Opens quickfix list with all breakpoint locations.

---

## Translators Command

```lua
vim.api.nvim_create_user_command('GodotTranslators', function(opts)
    vim.cmd('normal! A # TRANSLATORS: ')
end, {})
```

Appends translator comment to current line for localization.

**GDScript format:**
```gdscript
tr("Hello") # TRANSLATORS: Greeting message
```

---

## NERDTree Ignore

```lua
if is_godot_project then
    vim.cmd('let NERDTreeIgnore = ["\\.uid$", "server.pipe"]')
end
```

Ignores Godot 4.4+ `.uid` files and the server pipe in file tree.

---

## DAP Configuration

```lua
local dap = require('dap')

dap.adapters.godot = {
    type = "server",
    host = '127.0.0.1',
    port = 6006,
}

dap.configurations.gdscript = {
    {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
    }
}
```

### Godot Editor Debug Setup

1. **Editor → Editor Settings → General → Debugger → Wait For Debugger**
   - Enable to pause on breakpoints

2. **Editor → Editor Settings → Network → Debug Adapter**
   - Port should match (default: 6006)

### Debugging Workflow

1. Open Godot project in Neovim
2. Set breakpoints with `<leader>b`
3. In Godot: Run scene (F5)
4. In Neovim: `<leader>dc` to connect debugger
5. Execution pauses at breakpoints

---

## LSP Configuration

**File:** `lsp/gdscript.lua`

```lua
local port = os.getenv 'GDScript_Port' or '6005'
local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))

return {
    cmd = cmd,
    filetypes = { 'gd', 'gdscript', 'gdscript3' },
    root_markers = { 'project.godot', '.git' },
}
```

### Connection

The LSP connects to Godot's built-in language server.

**In Godot Editor:**
1. **Editor → Editor Settings → General → Language Server**
2. Enable **Enable Language Server**
3. Set port (default: 6005)

### Environment Variable

Override the port:
```bash
export GDScript_Port=6005
nvim my_project/
```

---

## File Types

| Extension | FileType |
|-----------|----------|
| `.gd` | gdscript |
| `.gdshader` | gdshader |
| `.tscn` | godot_resource |
| `.tres` | godot_resource |

---

## Treesitter Support

Required parsers (in `treesitter.lua`):

```lua
ensure_installed = { "gdscript", "godot_resource", "gdshader" }
```

---

## Keybindings Summary

| Key | Mode | Action |
|-----|------|--------|
| `<leader>b` | n | Insert breakpoint |
| `<leader>BD` | n | Delete all breakpoints in file |
| `<leader>BF` | n | Find all breakpoints in project |
| `<leader>dt` | n | Toggle DAP breakpoint |
| `<leader>dc` | n | Continue debugging |

---

## Troubleshooting

### LSP Not Connecting

1. Ensure Godot editor is running
2. Check Language Server is enabled in Godot settings
3. Verify port matches (6005 default)

### Debug Not Working

1. Ensure DAP adapter is configured (port 6006)
2. Check "Wait For Debugger" in Godot settings
3. Run scene from Godot first, then connect from Neovim

### Server Pipe Errors

If `server.pipe` already exists:
```bash
rm /path/to/project/server.pipe
```

Then restart Neovim.

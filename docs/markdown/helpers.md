---
title: "Helper Utilities"
tags:
  - utility
---

# Helper Utilities

**File:** `lua/util/helpers.lua`

Utility functions for async operations, file handling, and command execution.

---

## Overview

Provides reusable helper functions used across the configuration, particularly by the markdown filter system.

---

## Module Structure

```lua
local M = {}

M.create_cmd = function(command, f, opts) ... end
M.list_buffers = function() ... end
M.file_modified = function(path) ... end
M.run_cmd = function(args) ... end
M.list_files = function(path, cb) ... end

return M
```

---

## `create_cmd(command, f, opts)`

Create a Neovim user command.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `command` | string | Command name (e.g., `"MyCommand"`) |
| `f` | function | Command handler |
| `opts` | table | Optional command options |

### Example

```lua
local helpers = require("util.helpers")

helpers.create_cmd("HelloWorld", function()
    print("Hello, World!")
end, { desc = "Print hello message" })
```

### Usage

```
:HelloWorld
```

### Options

```lua
opts = {
    desc = "Command description",
    nargs = "*",      -- Arguments: "*", "?", "+", "0", "1"
    range = true,     -- Accept range
    complete = "file" -- Completion: "file", "dir", "command", etc.
}
```

---

## `list_buffers()`

Get a list of all valid, listed buffers.

### Returns

`table` - Array of buffer numbers

### Implementation

```lua
M.list_buffers = function()
    return vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) 
           and vim.api.nvim_buf_get_option(buf, "buflisted")
    end, vim.api.nvim_list_bufs())
end
```

### Example

```lua
local buffers = helpers.list_buffers()
for _, buf in ipairs(buffers) do
    local name = vim.api.nvim_buf_get_name(buf)
    print(buf .. ": " .. name)
end
```

---

## `file_modified(path)`

Get the last modification timestamp of a file.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `path` | string | File path |

### Returns

`number|nil` - Unix timestamp or nil if error

### Implementation

```lua
M.file_modified = function(path)
    local f = io.popen("stat -c %Y " .. path)
    if f then
        return tonumber(f:read())
    else
        return nil
    end
end
```

### Platform Note

Uses Linux `stat` command. For macOS, change to:
```lua
local f = io.popen("stat -f %m " .. path)
```

### Example

```lua
local modified = helpers.file_modified("/path/to/file.md")
if modified then
    local date = os.date("%Y-%m-%d %H:%M", modified)
    print("Last modified: " .. date)
end
```

---

## `run_cmd(args)`

Run an external command asynchronously using nvim-nio.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `args` | table | Command specification |

### Returns

`string|nil` - Command stdout or nil on error

### Implementation

```lua
M.run_cmd = function(args)
    local nio = require("nio")
    local proc = nio.process.run(args)

    if not proc then
        return nil
    end

    local err = proc.stderr.read()
    if err and string.len(err) ~= 0 then
        vim.notify("error: " .. err, vim.log.levels.ERROR)
        return nil
    end

    return proc.stdout.read()
end
```

### Args Format

```lua
args = {
    cmd = "fd",           -- Command name
    args = { "-t", "f", "\\", "/path" }  -- Arguments array
}
```

### Example

```lua
local output = helpers.run_cmd({
    cmd = "fd",
    args = { "-t", "f", "\\.md$", "/home/user/notes" }
})

if output then
    local files = vim.fn.split(output, "\n")
    for _, file in ipairs(files) do
        print(file)
    end
end
```

### Dependency

Requires **nvim-nio** for async operations.

---

## `list_files(path, cb)`

Asynchronously list all files in a directory using `fd`.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `path` | string | Directory to search |
| `cb` | function | Callback receiving file list |

### Implementation

```lua
M.list_files = function(path, cb)
    local nio = require("nio")
    nio.run(function()
        local output = M.run_cmd({
            cmd = "fd",
            args = { "-t", "f", "\\.", path }
        })

        if not output then
            return
        end

        nio.scheduler()  -- Return to main thread
        local files = vim.fn.split(output, "\n")
        cb(files)
    end)
end
```

### Example

```lua
helpers.list_files("/home/user/notes", function(files)
    for _, file in ipairs(files) do
        print(file)
    end
end)
```

### Why Async?

File listing can be slow for large directories. Using `nio.run` prevents blocking the UI.

### `nio.scheduler()`

Required before calling `cb()` to return execution to Neovim's main thread. Without it, callback operations that modify buffers/windows would fail.

---

## Dependencies

| Dependency | Used By |
|------------|---------|
| nvim-nio | `run_cmd`, `list_files` |
| fd | `list_files` (external command) |

---

## Usage in Config

These helpers are primarily used by:

- **markdown/filter.lua** - Async file listing and command execution
- **Custom commands** - `create_cmd` for user commands

### Import

```lua
local helpers = require("util.helpers")
```

---

## Extending the Module

### Add Git Helper

```lua
M.git_root = function()
    local output = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 then
        return output
    end
    return nil
end
```

### Add JSON Helper

```lua
M.read_json = function(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return vim.json.decode(content)
end
```

### Add Buffer Helper

```lua
M.buffer_contains = function(bufnr, pattern)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match(pattern) then
            return true
        end
    end
    return false
end
```

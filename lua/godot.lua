-- paths to check for project.godot file
local paths_to_check = {'/', '/../'}
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
        is_godot_project = true
        godot_project_path = cwd .. value
        break
    end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
    vim.fn.serverstart(godot_project_path .. '/server.pipe')
end

-- define functions only for Godot projects
if is_godot_project then
    -- write breakpoint to new line
    vim.api.nvim_create_user_command('GodotBreakpoint', function()
        vim.cmd('normal! obreakpoint' )
        vim.cmd('write' )
    end, {})
    vim.keymap.set('n', '<leader>b', ':GodotBreakpoint<CR>')

    -- delete all breakpoints in current file
    vim.api.nvim_create_user_command('GodotDeleteBreakpoints', function()
        vim.cmd('g/breakpoint/d')
    end, {})
    vim.keymap.set('n', '<leader>BD', ':GodotDeleteBreakpoints<CR>')

    -- search all breakpoints in project
    vim.api.nvim_create_user_command('GodotFindBreakpoints', function()
        vim.cmd(':grep breakpoint | copen')
    end, {})
    vim.keymap.set('n', '<leader>BF', ':GodotFindBreakpoints<CR>')

    -- append "# TRANSLATORS: " to current line
    vim.api.nvim_create_user_command('GodotTranslators', function(opts)
        vim.cmd('normal! A # TRANSLATORS: ')
    end, {})
end
-- define functions only for Godot projects
if is_godot_project then
    -- write breakpoint to new line
    vim.api.nvim_create_user_command('GodotBreakpoint', function()
        vim.cmd('normal! obreakpoint' )
        vim.cmd('write' )
    end, {})
    vim.keymap.set('n', '<leader>b', ':GodotBreakpoint<CR>')

    -- delete all breakpoints in current file
    vim.api.nvim_create_user_command('GodotDeleteBreakpoints', function()
        vim.cmd('g/breakpoint/d')
    end, {})
    vim.keymap.set('n', '<leader>BD', ':GodotDeleteBreakpoints<CR>')

    -- search all breakpoints in project
    vim.api.nvim_create_user_command('GodotFindBreakpoints', function()
        vim.cmd(':grep breakpoint | copen')
    end, {})
    vim.keymap.set('n', '<leader>BF', ':GodotFindBreakpoints<CR>')

    -- append "# TRANSLATORS: " to current line
    vim.api.nvim_create_user_command('GodotTranslators', function(opts)
        vim.cmd('normal! A # TRANSLATORS: ')
    end, {})
end

if is_godot_project then
    -- ignore *.uid files introduced in godot 4.4
    -- ignore server.pipe file
    vim.cmd('let NERDTreeIgnore = ["\\.uid$", "server.pipe"]')
end

-- dubugging
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


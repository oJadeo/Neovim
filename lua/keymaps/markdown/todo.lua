-- Detect todos and toggle between ":" and ";", or show a message if not found
-- This is to "mark them as done"
vim.keymap.set("n", "<leader>td", function()
	-- Get the current line
	local current_line = vim.fn.getline(".")
	-- Get the current line number
	local line_number = vim.fn.line(".")
	if string.find(current_line, "TODO:") then
		-- Replace the first occurrence of ":" with ";"
		local new_line = current_line:gsub("TODO:", "TODO;")
		-- Set the modified line
		vim.fn.setline(line_number, new_line)
	elseif string.find(current_line, "TODO;") then
		-- Replace the first occurrence of ";" with ":"
		local new_line = current_line:gsub("TODO;", "TODO:")
		-- Set the modified line
		vim.fn.setline(line_number, new_line)
	else
		vim.cmd("echo 'todo item not detected'")
	end
end, { desc = "[T]oggle TODO [D]one " })

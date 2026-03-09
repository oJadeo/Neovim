-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
-- hardtime.nvim causes issues with this key, you have to unrestrict it in the
-- plugin config
vim.keymap.set({ "n", "v" }, "gk", function()
	-- `?` - Start a search backwards from the current cursor position.
	-- `^` - Match the beginning of a line.
	-- `##` - Match 2 ## symbols
	-- `\\+` - Match one or more occurrences of prev element (#)
	-- `\\s` - Match exactly one whitespace character following the hashes
	-- `.*` - Match any characters (except newline) following the space
	-- vim.cmd("silent! ?^##\\+\\s.*$")
	local ft = vim.bo.filetype
	if ft == "typst" then
		vim.cmd("silent! ?^==\\+\\s.*$")
		-- Clear the search highlight
		vim.cmd("nohlsearch")
		return
	end -- `$` - Match extends to end of line
	vim.cmd("silent! ?^##\\+\\s.*$")
	-- Clear the search highlight
	vim.cmd("nohlsearch")
end, { desc = "[P]Go to previous markdown header" })

-- HACK: Jump between markdown headings in lazyvim
-- https://youtu.be/9S7Zli9hzTE
--
-- Search DOWN for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
-- hardtime.nvim causes issues with this key, you have to unrestrict it in the
-- plugin config
vim.keymap.set({ "n", "v" }, "gj", function()
	-- `/` - Start a search forwards from the current cursor position.
	-- `^` - Match the beginning of a line.
	-- `##` - Match 2 ## symbols
	-- `\\+` - Match one or more occurrences of prev element (#)
	-- `\\s` - Match exactly one whitespace character following the hashes
	-- `.*` - Match any characters (except newline) following the space
	-- `$` - Match extends to end of line
	local ft = vim.bo.filetype
	if ft == "typst" then
		vim.cmd("silent! /^==\\+\\s.*$")
		-- Clear the search highlight
		vim.cmd("nohlsearch")
		return
	end
	vim.cmd("silent! /^##\\+\\s.*$")
	-- Clear the search highlight
	vim.cmd("nohlsearch")
end, { desc = "[P]Go to next markdown header" })

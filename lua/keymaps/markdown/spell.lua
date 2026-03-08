-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Keymap to switch spelling language to English lamw25wmal
-- To save the language settings configured on each buffer, you need to add
-- "localoptions" to vim.opt.sessionoptions in the `lua/config/options.lua` file
vim.keymap.set("n", "<leader>msle", function()
	vim.opt.spelllang = "en"
	vim.cmd("echo 'Spell language set to English'")
end, { desc = "[P]Spelling language English" })

-- Show spelling suggestions / spell suggestions
-- NOTE: I changed this to accept the first spelling suggestion
vim.keymap.set("n", "<leader>mss", function()
	-- Simulate pressing "z=" with "m" option using feedkeys
	-- vim.api.nvim_replace_termcodes ensures "z=" is correctly interpreted
	-- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
	-- If {mode} is absent, keys are remapped.
	--
	-- I tried this keymap as usually with
	vim.cmd("normal! 1z=")
	-- But didn't work, only with nvim_feedkeys
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
end, { desc = "[M]ark [S]pelling [S]uggestions" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- markdown good, accept spell suggestion
-- Add word under the cursor as a good word
vim.keymap.set("n", "<leader>msa", function()
	vim.cmd("normal! zg")
	-- I do a write so that harper is updated
	vim.cmd("silent write")
end, { desc = "[M]arkdown [S]pelling [A]dd word to spellfile" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Undo zw, remove the word from the entry in 'spellfile'.
vim.keymap.set("n", "<leader>msu", function()
	vim.cmd("normal! zug")
end, { desc = "[M]arkdown [S]pelling [U]ndo, remove word from list" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Repeat the replacement done by |z=| for all matches with the replaced word
-- in the current window.
vim.keymap.set("n", "<leader>msr", function()
	-- vim.cmd(":spellr")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "[M]arkdown [S]pelling [R]epeat" })

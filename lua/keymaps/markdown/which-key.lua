-- Mappings for creating new groups that don't exist
-- When I press leader, I want to modify the name of the options shown
-- "m" is for "markdown" and "t" is for "todo"
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
local wk = require("which-key")
wk.add({
	{
		mode = { "n" },
		{ "<leader>t", group = "[T]odo" },
	},
	{
		mode = { "n", "v" },
		{ "<leader>m", group = "[M]arkdown" },
		{ "<leader>mf", group = "[M]arkdown [F]old" },
		{ "<leader>mh", group = "[M]arkdown [H]eading increase/decrease" },
		{ "<leader>ml", group = "[M]arkdown [L]ink" },
		{ "<leader>ms", group = "[M]arkdown [S]pell" },
		{ "<leader>msl", group = "[M]arkdown [S]pell [L]anguage" },
	},
})

---@diagnostic disable: missing-fields
return {
	-- {
	-- 	"obsidian-nvim/obsidian.nvim",
	-- 	version = "*", -- recommended, use latest release instead of latest commit
	-- 	lazy = true,
	-- 	ft = "markdown",
	-- 	dependencies = {
	-- 		-- Required.
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	completion = {
	-- 		blink = true,
	-- 	},
	-- 	picker = {
	-- 		name = "telescope",
	-- 	},
	-- 	ui = {
	-- 		enable = false,
	-- 	},
	-- 	config = function()
	-- 		require("obsidian").setup({
	-- 			workspaces = {
	-- 				{
	-- 					name = "Home",
	-- 					path = "/mnt/nvme/Obsidian/SecondBrain/",
	-- 				},
	-- 				{
	-- 					name = "Work",
	-- 					path = "/mnt/d/Obsidian/SecondBrain/",
	-- 				},
	-- 			},
	-- 			templates = {
	-- 				folder = "99-MetaData/Template",
	-- 			},
	-- 		})
	-- 		vim.keymap.set("n", "<leader>onn", "<cmd>Obsidian new<cr>", { desc = "[N]ew Obsidian Note" })
	-- 		vim.keymap.set("n", "<leader>ont", "<cmd>Obsidian new_from_template <cr>", { desc = "[N]ew [T]emplate" })
	-- 		vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian search<cr>", { desc = "Search [O]bisidian Notes" })
	-- 		vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian tags<cr>", { desc = "Search [T]ags" })
	-- 		vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "Table of [C]ontent" })
	-- 		vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Search [B]ackLinks" })
	-- 		vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Search [L]inks" })
	-- 		vim.keymap.set("v", "<leader>oe", "<cmd>Obsidian extract_note", { desc = "[E]xtract to new note" })
	-- 	end,
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- Make Markdown buffers look beautiful
		ft = { "markdown", "codecompanion" },
		opts = {
			render_modes = true, -- Render in ALL modes
			-- other options...
		},
		config = function()
			require("render-markdown").setup({
				completions = { lsp = { enabled = true } },
				checkbox = {
					checked = { scope_highlight = "@markup.strikethrough" },
				},
			})
		end,
	},
	-- {
	-- 	"magnusriga/markdown-tools.nvim",
	-- 	opts = {
	-- 		picker = "telescope",
	-- 	},
	-- },
}

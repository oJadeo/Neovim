local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit" },
	callback = function()
		-- -- By default wrap is set to true regardless of what I chose in my options.lua file,
		-- -- This sets wrapping for my skitty-notes and I don't want to have
		-- -- wrapping there, I wanto to decide this in the options.lua file
		-- vim.opt_local.wrap = false
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "markdown" },
	callback = function(args)
		-- -- By default wrap is set to true regardless of what I chose in my options.lua file,
		-- -- This sets wrapping for my skitty-notes and I don't want to have
		-- -- wrapping there, I wanto to decide this in the options.lua file
		-- vim.opt_local.wrap = false
		vim.opt_local.spell = true
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "markdown" },
	callback = function(args)
		-- Check if treesitter can start for the buffer and language
		local bufnr = args.buf
		local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
		if lang then
			pcall(vim.treesitter.start, bufnr, lang) -- Safely call vim.treesitter.start
			-- Optional: ensure regex syntax is still active for some plugins
			-- vim.bo[bufnr].syntax = "on"
		end
	end,
})

-- Enable LSP codelens auto-refresh only for markdown buffers
-- Keeps LazyVim global codelens disabled, but gives markdown-oxide its reference count lenses automatically
local function codelens_supported(bufnr)
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if c.server_capabilities and c.server_capabilities.codeLensProvider then
			return true
		end
	end
	return false
end
-- Refresh codelens only when the current buffer is markdown and the attached client supports it
local function refresh_markdown_codelens(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end
	if vim.bo[bufnr].buftype ~= "" then
		return
	end
	if vim.bo[bufnr].filetype ~= "markdown" then
		return
	end
	if not codelens_supported(bufnr) then
		return
	end
	vim.lsp.codelens.refresh({ bufnr = bufnr })
end
-- Create markdown-only codelens refresh triggers
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "TextChanged" }, {
	callback = function(args)
		refresh_markdown_codelens(args.buf)
	end,
})

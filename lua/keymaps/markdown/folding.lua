local function get_markdown_headings()
	local cursor_line = vim.fn.line(".")
	local parser = vim.treesitter.get_parser(0, "markdown")
	if not parser then
		vim.notify("Markdown parser not available", vim.log.levels.ERROR)
		return nil, nil, nil, nil, nil, nil
	end
	local tree = parser:parse()[1]
	local query = vim.treesitter.query.parse(
		"markdown",
		[[
    (atx_heading (atx_h1_marker) @h1)
    (atx_heading (atx_h2_marker) @h2)
    (atx_heading (atx_h3_marker) @h3)
    (atx_heading (atx_h4_marker) @h4)
    (atx_heading (atx_h5_marker) @h5)
    (atx_heading (atx_h6_marker) @h6)
  ]]
	)
	-- Collect and sort all headings
	local headings = {}
	for id, node in query:iter_captures(tree:root(), 0) do
		local start_line = node:start() + 1 -- Convert to 1-based
		table.insert(headings, { line = start_line, level = id })
	end
	table.sort(headings, function(a, b)
		return a.line < b.line
	end)
	-- Find current heading and track its index
	local current_heading, current_idx, next_heading, next_same_heading
	for idx, h in ipairs(headings) do
		if h.line <= cursor_line then
			current_heading = h
			current_idx = idx
		elseif not next_heading then
			next_heading = h -- First heading after cursor
		end
	end
	-- Find next same-level heading if current exists
	if current_heading then
		-- Look for next same-level after current index
		for i = current_idx + 1, #headings do
			local h = headings[i]
			if h.level == current_heading.level then
				next_same_heading = h
				break
			end
		end
	end
	-- Return all values (nil if not found)
	return current_heading and current_heading.line or nil,
		current_heading and current_heading.level or nil,
		next_heading and next_heading.line or nil,
		next_heading and next_heading.level or nil,
		next_same_heading and next_same_heading.line or nil,
		next_same_heading and next_same_heading.level or nil
end

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(lnum)
	local heading = line:match("^(#+)%s")
	if heading then
		local level = #heading
		if level == 1 then
			-- Special handling for H1
			if lnum == 1 then
				return ">1"
			else
				local frontmatter_end = vim.b.frontmatter_end
				if frontmatter_end and (lnum == frontmatter_end + 1) then
					return ">1"
				end
			end
		elseif level >= 2 and level <= 6 then
			-- Regular handling for H2-H6
			return ">" .. level
		end
	end
	return "="
end

function _G.typst_foldexpr()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(lnum)
	local heading = line:match("^(=+)%s")
	if heading then
		local level = #heading
		if level >= 1 and level <= 6 then
			return ">" .. level
		end
	end
	return "="
end

local function set_markdown_folding()
	vim.opt_local.foldmethod = "expr"
	vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
	vim.opt_local.foldlevel = 99

	-- Detect frontmatter closing line
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local found_first = false
	local frontmatter_end = nil
	for i, line in ipairs(lines) do
		if line == "---" then
			if not found_first then
				found_first = true
			else
				frontmatter_end = i
				break
			end
		end
	end
	vim.b.frontmatter_end = frontmatter_end
end

local function set_typst_folding()
	vim.opt_local.foldmethod = "expr"
	vim.opt_local.foldexpr = "v:lua.typst_foldexpr()"
	vim.opt_local.foldlevel = 99
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = set_markdown_folding,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = set_typst_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
	-- Move to the top of the file without adding to jumplist
	vim.cmd("keepjumps normal! gg")
	-- Get the total number of lines
	local total_lines = vim.fn.line("$")
	for line = 1, total_lines do
		-- Get the content of the current line
		local line_content = vim.fn.getline(line)
		if vim.bo.filetype == "typst" then
			if line_content:match("^" .. string.rep("=", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		else
			-- "^" -> Ensures the match is at the start of the line
			-- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
			-- "%s" -> Matches any whitespace character after the "#" characters
			-- So this will match `## `, `### `, `#### ` for example, which are markdown headings
			if line_content:match("^" .. string.rep("#", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		end
	end
end

local function fold_markdown_headings(levels)
	-- I save the view to know where to jump back after folding
	local saved_view = vim.fn.winsaveview()
	for _, level in ipairs(levels) do
		fold_headings_of_level(level)
	end
	vim.cmd("nohlsearch")
	-- Restore the view to jump to where I was
	vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfj", function()
	-- Reloads the file to refresh folds, otheriise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfk", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfl", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mf;", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz") -- center the cursor line on screen
	end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfu", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	vim.cmd("normal! zR") -- Unfold all headings
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[U]nfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- Difference between normal and normal!
	-- - `normal` executes the command and respects any mappings that might be defined.
	-- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
	vim.cmd("normal gk")
	-- This is to fold the line under the cursor
	vim.cmd("normal! za")
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "Fold the heading cursor currently on" })

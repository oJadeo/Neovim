local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local telescope_utils = require("telescope.utils")
local helpers = require("util.helpers")
local nio = require("nio")

local function split_prompt(prompt)
	local tags = {}
	local project = {}
	local path = {}
	for word in prompt:gmatch("([^%s]+)") do
		local fst = word:sub(1, 1)
		if fst == "#" then
			table.insert(tags, word:sub(2))
		elseif fst == "@" then
			table.insert(project, word:sub(2))
		else
			table.insert(path, word)
		end
	end

	return {
		tags = tags,
		project = project,
		path = path,
	}
end

local function score_element(prompt_elements, entry_element, sorter)
	if prompt_elements == nil then
		return 0
	end

	-- We didn't prompt for this type, ignore it.
	if next(prompt_elements) == nil then
		return 0
	end

	-- We prompted for this type, but entry didn't have it, so remove the entry.
	-- For example if we prompt for a series, this removes all posts
	-- without a series.
	if not entry_element then
		return -1
	end

	-- Convert multiple entry values to a string like `tag1:tag2`.
	local entry
	if type(entry_element) == "string" then
		entry = entry_element
	elseif type(entry_element) == "table" then
		entry = vim.fn.join(entry_element, ":")
	end

	local total = 0
	for _, prompt_element in ipairs(prompt_elements) do
		local score = sorter:scoring_function(prompt_element, entry)
		-- Require a match for every element.
		if score < 0 then
			return -1
		end
		total = total + score
	end

	-- Clamp score to max 1.
	return total / #prompt_elements
end

local function score_item_type(item)
	local function item_score()
		if item.type == "Knowledge" then
			return 0.1
		elseif item.type == "Analysis" then
			return 0.11
		elseif item.type == "Note" then
			return 0.12
		else
			-- vim.notify("Unknown item type: " .. item.type, vim.log.levels.ERROR)
			return 0
		end
	end

	return item_score()
end

local function score_date(entry)
	local entry_date
	if entry.created then
		-- Remove `-` from entry date, so it's like a number.
		entry_date = string.gsub(entry.created, "-", "")
	elseif entry.published then
		-- Remove `-` from entry date, so it's like a number.
		entry_date = string.gsub(entry.published, "-", "")
	elseif entry.year then
		entry_date = tostring(entry.year) .. "0000"
	end

	if not entry_date then
		return 1
	end

	-- Date of my first blog post as a number.
	local beginning_of_time = 20090621
	-- Today's date as a number.
	local today = os.date("%Y%m%d")
	-- Place the number on a 0..1 scale, where 1 is today (`1 -` reverses, otherwise 1
	-- would be the beginning of time).
	return 1 - (entry_date - beginning_of_time) / (today - beginning_of_time)
end

local function content_sorter(opts)
	opts = opts or {}
	local fzy_sorter = sorters.get_fzy_sorter(opts)

	return sorters.Sorter:new({
		discard = true,

		scoring_function = function(_, prompt, entry)
			prompt = split_prompt(prompt)

			-- Score and filter against series, tags, and title separately.
			-- If any element returns a 0, it means nothing matched but we shouldn't filter.
			-- If it returns < 0, it means it did not match and should remove the entry.
			local project_score = score_element(prompt.project, entry.project, fzy_sorter)
			if project_score < 0 then
				return -1
			end

			local tags_score = score_element(prompt.tags, entry.tags, fzy_sorter)
			if tags_score < 0 then
				return -1
			end

			local path_score = score_element(prompt.path, entry.path, fzy_sorter)
			if path_score < 0 then
				return -1
			end

			local type_score = score_item_type(entry)
			local date_score = score_date(entry)

			-- Date sorting is only worth 1/10 of the fuzzy scores.
			-- Why? I dunno, it felt like 1 was too much and 1/10 felt good.
			return project_score + tags_score + path_score + date_score / 10 + type_score
		end,
	})
end

local function make_knowledge_display(item)
	local icon = "󱛉"

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = string.len(item.path) },
			{ remaining = true },
		},
	})

	return displayer({
		{ icon, "TelescopeResultsComment" },
		item.path,
		{ tostring(item.year), "TelescopeResultsComment" },
	})
end
local function make_analysis_display(item)
	local icon = ""

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = string.len(item.path) },
			{ remaining = true },
		},
	})

	return displayer({
		{ icon, "TelescopeResultsComment" },
		item.path,
		{ tostring(item.year), "TelescopeResultsComment" },
	})
end

local function make_note_display(item)
	local icon = "󱞁"

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = string.len(item.path) },
			{ remaining = true },
		},
	})

	return displayer({
		{ icon, "TelescopeResultsComment" },
		item.path,
		{ tostring(item.year), "TelescopeResultsComment" },
	})
end

local function make_display(entry)
	local item = entry.value
	if item.type == "Knowledge" then
		return make_knowledge_display(item)
	elseif item.type == "Analysis" then
		return make_analysis_display(item)
	elseif item.type == "Note" then
		return make_note_display(item)
	else
		local icon = ""
		local displayer = entry_display.create({
			separator = " ",
			items = {
				{ width = 1 },
				{ width = string.len(item.path) },
				{ remaining = true },
			},
		})

		return displayer({
			{ icon, "TelescopeResultsComment" },
			item.path,
			{ tostring(item.alias), "TelescopeResultsComment" },
		})
	end
end

local function trim_quotes(s)
	local stripped = string.match(s, '^"(.+)"$')
	if stripped then
		return stripped
	else
		return s
	end
end

local function format_data(output)
	local lines = vim.fn.split(output, "\n")
	local posts = {}

	local post = {}
	for _, line in ipairs(lines) do
		-- When a newline is encountered save the post and prepare for the next entry.
		if line == "" then
			if next(post) ~= nil then
				table.insert(posts, post)
			end
			post = {}
		-- Skip `---` markers.
		elseif not string.match(line, "%-%-%-%w*") then
			-- Try to extract all key value definitions and store them.
			local key, value = string.match(line, "(%w+)%s*[:=]%s*(.+)")
			if key then
				-- Strip surrounding quotes.
				-- Do this here because there's no non-greedy specifier that could be used
				-- in the key/value regex above.
				value = trim_quotes(value)
				-- Split a sequence.
				local seq = string.match(value, "^%[(.+)%]$")
				if seq then
					local parts = {}
					for part in string.gmatch(seq, "%s*([^,]+)") do
						table.insert(parts, trim_quotes(part))
					end
					value = parts
				end
				post[key] = value
			else
				-- If no key value pair is found, then we should be at the beginning with the file path.
				post["path"] = line
				-- Only posts have a date in the path, not drafts.
				local date = string.match(line, "posts/(%d%d%d%d%-%d%d%-%d%d)%-")
				if date then
					post["date"] = date
				else
					-- Use the modified timestamp for drafts.
					-- post["date"] = os.date("%Y-%m-%d", util.file_modified(line))
				end
			end
		end
	end
	-- If output ends we might have an unsaved post.
	if post.path then
		table.insert(posts, post)
	end

	return posts
end

local function list_markup_content(cb)
	local output = vim.fn.system("rg -NoHU --heading '\\A\\---\\w*\\n(.+\\n)+^---'")

	-- local output = rg.stdout
	if output then
		local posts = format_data(output)
		cb(posts)
	end
end

local function find_markup(opts)
	opts = opts or {}

	list_markup_content(function(files)
		pickers
			.new(opts, {
				finder = finders.new_table({
					results = files,
					entry_maker = function(entry)
						return {
							display = make_display,
							ordinal = entry,
							value = entry,
							-- Make standard action open `path` on <CR>
							filename = entry.path,
						}
					end,
				}),
				sorter = content_sorter(opts),
				previewer = previewers.new_buffer_previewer({
					title = "Content Preview",
					define_preview = function(self, entry)
						conf.buffer_previewer_maker(entry.value.path, self.state.bufnr, {
							bufname = self.state.bufname,
							winid = self.state.winid,
							preview = true,
							file_encoding = "UTF-8",
						})
					end,
				}),
			})
			:find()
	end)
end

vim.keymap.set("n", "<leader>mt", function()
	find_markup()
end, { desc = "[M]arkdown filter [T]ag" })

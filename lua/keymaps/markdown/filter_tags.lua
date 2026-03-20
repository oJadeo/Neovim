local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")

local function extract_all_tags(cb)
	local output = vim.fn.system(
		"rg -NoHU --multiline -- '(?m)^tags:\\s*\\[([^\\]]+)\\]|^tags:\\s*$\\n((?:^\\s*-\\s+.+$\\n?)+)' ."
	)

	if not output or output == "" then
		vim.notify("No tags found in markdown files", vim.log.levels.WARN)
		return
	end

	local tag_files = {}
	local current_file = nil

	for line in output:gmatch("[^\n]+") do
		local file_match = line:match("^([^:]+%.md):")
		if file_match then
			current_file = file_match
		end

		local inline_tags = line:match("tags:%s*%[([^%]]+)%]")
		if inline_tags and current_file then
			for tag in inline_tags:gmatch("[^,%s]+") do
				tag = tag:gsub('^["\']+', ""):gsub('["\']+$', "")
				if tag ~= "" then
					tag_files[tag] = tag_files[tag] or {}
					if not vim.tbl_contains(tag_files[tag], current_file) then
						table.insert(tag_files[tag], current_file)
					end
				end
			end
		else
			local list_tag = line:match("^.+%.md:%s*-%s*(.+)$")
			if list_tag then
				list_tag = list_tag:gsub('^["\']+', ""):gsub('["\']+$', "")
				if list_tag ~= "" and current_file then
					tag_files[list_tag] = tag_files[list_tag] or {}
					if not vim.tbl_contains(tag_files[list_tag], current_file) then
						table.insert(tag_files[list_tag], current_file)
					end
				end
			end
		end
	end

	cb(tag_files)
end

local function make_tag_display(entry)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 20 },
			{ width = 5 },
		},
	})

	return displayer({
		{ entry.value.tag, "TelescopeResultsIdentifier" },
		{ "(" .. #entry.value.files .. ")", "TelescopeResultsComment" },
	})
end

local function make_file_display(entry)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ remaining = true },
		},
	})

	return displayer({
		{ entry.value.path, "TelescopeResultsFunction" },
	})
end

local function files_for_tags(tag_files, selected_tags)
	local file_counts = {}
	for _, tag in ipairs(selected_tags) do
		local files = tag_files[tag]
		if files then
			for _, file in ipairs(files) do
				file_counts[file] = (file_counts[file] or 0) + 1
			end
		end
	end

	local matching_files = {}
	local required_count = #selected_tags
	for file, count in pairs(file_counts) do
		if count >= required_count then
			table.insert(matching_files, {
				path = file,
				tags = selected_tags,
			})
		end
	end

	table.sort(matching_files, function(a, b)
		return a.path < b.path
	end)

	return matching_files
end

local show_file_picker

local function show_tag_picker(tag_files, opts)
	opts = opts or {}

	local tags = {}
	for tag, files in pairs(tag_files) do
		table.insert(tags, { tag = tag, files = files })
	end
	table.sort(tags, function(a, b)
		return a.tag < b.tag
	end)

	pickers
		.new(opts, {
			prompt_title = "Select tags (Tab to multi-select, Enter to search)",
			finder = finders.new_table({
				results = tags,
				entry_maker = function(entry)
					return {
						display = make_tag_display,
						ordinal = entry.tag,
						value = entry,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = false,
			attach_mappings = function(prompt_bufnr, map)
				if opts.preselected_tags then
					vim.defer_fn(function()
						local current_picker = action_state.get_current_picker(prompt_bufnr)
						action_utils.map_entries(prompt_bufnr, function(entry, _, row)
							if vim.tbl_contains(opts.preselected_tags, entry.value.tag) then
								current_picker:set_selection(row)
								actions.toggle_selection(prompt_bufnr)
							end
						end)
					end, 50)
				end

				actions.select_default:replace(function()
					local current_picker = action_state.get_current_picker(prompt_bufnr)
					local selections = current_picker:get_multi_selection()

					if vim.tbl_isempty(selections) then
						local selection = action_state.get_selected_entry()
						if selection then
							selections = { selection }
						end
					end

					actions.close(prompt_bufnr)

					if vim.tbl_isempty(selections) then
						return
					end

					local selected_tags = {}
					for _, sel in ipairs(selections) do
						if type(sel) == "table" and sel.value then
							table.insert(selected_tags, sel.value.tag)
						end
					end

					local matching_files = files_for_tags(tag_files, selected_tags)

					if #matching_files == 0 then
						vim.notify("No files match all selected tags", vim.log.levels.WARN)
						return
					end

					show_file_picker(matching_files, tag_files, opts, selected_tags)
				end)

				return true
			end,
		})
		:find()
end

show_file_picker = function(files, tag_files, opts, selected_tags)
	opts = opts or {}
	selected_tags = selected_tags or {}

	pickers
		.new(opts, {
			prompt_title = "Files with selected tags (Esc to change tags)",
			finder = finders.new_table({
				results = files,
				entry_maker = function(entry)
					return {
						display = make_file_display,
						ordinal = entry.path,
						value = entry,
						filename = entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.new_buffer_previewer({
				title = "File Preview",
				define_preview = function(self, entry)
					conf.buffer_previewer_maker(entry.value.path, self.state.bufnr, {
						bufname = self.state.bufname,
						winid = self.state.winid,
						file_encoding = "UTF-8",
					})
				end,
			}),
			attach_mappings = function(_, map)
				actions.select_default:replace(function(bufnr)
					local selection = action_state.get_selected_entry()
					actions.close(bufnr)
					if selection then
						vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path))
					end
				end)
				map("i", "<Esc>", function(bufnr)
					actions.close(bufnr)
					vim.schedule(function()
						show_tag_picker(tag_files, vim.tbl_extend("force", opts, { preselected_tags = selected_tags }))
					end)
				end)
				map("n", "<Esc>", function(bufnr)
					actions.close(bufnr)
					vim.schedule(function()
						show_tag_picker(tag_files, vim.tbl_extend("force", opts, { preselected_tags = selected_tags }))
					end)
				end)
				return true
			end,
		})
		:find()
end

local function find_by_tags(opts)
	opts = opts or {}

	extract_all_tags(function(tag_files)
		if vim.tbl_isempty(tag_files) then
			return
		end
		show_tag_picker(tag_files, opts)
	end)
end

vim.keymap.set("n", "<leader>mt", function()
	find_by_tags()
end, { desc = "[M]arkdown filter by [T]ags" })

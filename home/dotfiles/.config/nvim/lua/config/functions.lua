-- Define an interactive vimgrep search function that populates the quickfix
function NompazVimgrepInFile()
    -- Prompt the user for a search term
    local search_term = vim.fn.input("Vimgrep Search: ")

    -- Check if the search term is not empty
    if search_term ~= "" then
        -- Run vimgrep on the current file
        vim.cmd("vimgrep /" .. search_term .. "/gj %")

        -- Open the quickfix list to display results
        vim.cmd("copen")
    else
        print("No search term entered.")
    end
end

-- Function to populate the quickfix list with session files
function NompazLoadSessions()

    local session_dir = vim.fn.expand("~/.local/share/nvim/sessions/") -- Expand `~` to the absolute path
    local sessions = {}

    -- Use vim.loop to scan the directory for session files
    local handle = vim.loop.fs_scandir(session_dir)
    if handle then
        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if type == "file" and name:match("%.vim$") then -- Assuming session files end with `.vim`
                table.insert(sessions, {
                   text = session_dir ..  name,
                })
            end
        end
    end

    if #sessions > 0 then
        -- Populate the quickfix list with the session files
	-- First, replace the quickfix list with the items
        vim.fn.setqflist(sessions, "r")

	-- Then, set the title
        vim.fn.setqflist({}, 'r', { title = "Load sessions" })       

        vim.cmd("copen") -- Open the quickfix window to view the files
    else
        print("No session files found in " .. session_dir)
    end
end

-- Define a custom quickfix handler to restore the selected session
function LoadSessionFromQuickfix()
    local qflist = vim.fn.getqflist({ idx = 0, items = 0 })
    local idx = qflist.idx -- Get the current selection index
    local items = qflist.items -- Get all entries in the quickfix list

    if idx and items[idx] then
        local selected_item = items[idx]

        -- Example: Print the filename and text of the selected entry
        print("Opening session file: " .. selected_item.text)

        -- Load the session file
	
	-- Ask the user whether they want to close buffers not in the session
        local close_buffers = vim.fn.confirm("Do you want to close buffers not in the session?", "&Yes\n&No", 2)
	
	if close_buffers == 1 then
	        vim.cmd("silent! bufdo bwipeout") -- Close all open buffers
	end
        vim.cmd("silent! source " .. selected_item.text) -- Source the session file
    else
        print("No entry selected.")
    end
    vim.fn.setqflist({}, 'r', { title = "" })       
end



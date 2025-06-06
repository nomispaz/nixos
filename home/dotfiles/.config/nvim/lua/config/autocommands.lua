-- Define a command to save session with user input
vim.api.nvim_create_user_command('NompazSaveSession', function()

    -- Define the session folder
    local session_folder = vim.fn.expand("~/.local/share/nvim/sessions/")

    -- Get the list of existing session files in the directory
    local session_files = vim.fn.glob(session_folder .. "*.vim", false, true)

    -- If there are existing files, display them
    if #session_files > 0 then
        print("Existing session files:")
        for _, file in ipairs(session_files) do
            print("  " .. vim.fn.fnamemodify(file, ":t"))  -- Print the filenames without path
        end
    else
        print("No existing session files.")
    end

    -- Prompt the user for the session filename
    local filename = vim.fn.input("Enter session filename (without extension .vim): ")

    -- Check if the filename is not empty
    if filename and filename ~= "" then
        -- Save the session using the filename provided by the user
        vim.cmd("mks! " .. vim.fn.expand(session_folder .. filename .. ".vim"))
    else
        print("Invalid filename!")
    end
end, { nargs = 0 })  -- We don't need arguments for this command

vim.api.nvim_create_autocmd(
     {"BufEnter"}, 
     { pattern = "*",    
     desc = "Automatically change directory to directory of current file",
     command = "cd %:p:h"
    }
 )

-- save the session on close
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
      -- runs :mks! to save the session
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = event.buf}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- You can find details of these function in the help page
    -- see for example, :help vim.lsp.buf.hover()

    -- Trigger code completion
    bufmap('i', '<C-Space>', '<C-x><C-o>')

    -- Display documentation of the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Format current file
    bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  end
})

-- Set autocommands to naviagate the session load quickfix list
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        local qfinfo = vim.fn.getqflist({ title = 0 })
        if qfinfo.title == "Load sessions" then
            vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<Down>",
                "<Cmd>cnext<CR>",
                { noremap = true, silent = true }
            )
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        local qfinfo = vim.fn.getqflist({ title = 0 })
        if qfinfo.title == "Load sessions" then
            vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<Up>",
                "<Cmd>cprev<CR>",
                { noremap = true, silent = true }
            )
        end
    end,
})

-- Set up an autocmd for the session load quickfix list to capture and overwrite <cr>
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        -- Map <CR> only if the quickfix list matches the title
        local qfinfo = vim.fn.getqflist({ title = 0 })
        if qfinfo.title == "Load sessions" then
            vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<CR>",
                "<Cmd>lua LoadSessionFromQuickfix()<CR>",
                { noremap = true, silent = true }
            )
	end
    end,
})

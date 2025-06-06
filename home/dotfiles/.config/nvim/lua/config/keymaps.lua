local keymap = vim.api.nvim_set_keymap

--work with buffers
keymap("n", "<leader><tab>", "<cmd>Telescope buffers<cr>", { desc = "Switch buffer" })
keymap("n", "<c-w>k", "<cmd>bd<cr>", { desc = "Close buffer" })

--session management
-- save the last session
keymap("n", "<leader>ss", "<cmd>NompazSaveSession<cr>", { desc = "Save current session to the defined session file" })
-- load the last session
keymap("n", "<leader>sl", "<cmd>lua NompazLoadSessions()<cr>", { desc = "Load sessions from quickfix list" })

-- Telescope functions
-- find files
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Open file search" })
-- find in files
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Search files (grep)" })
-- show recent files
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Show recent files" })

-- new file
keymap("n", "<leader>fn", "<cmd>ene <BAR> startinsert<cr>", { desc = "New file" })
-- show keymaps
keymap("n", "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Show keymaps" })

-- search
keymap("n", "<C-f>", "<cmd>lua NompazVimgrepInFile()<cr>", { desc = "Search string in file and display in quickfixlist" })


--navigate windows
--up
keymap("n", "<leader><Up>", "<cmd>wincmd k<cr>", { desc = "Move to window above" })
--down
keymap("n", "<leader><Down>", "<cmd>wincmd j<cr>", { desc = "Move to window below" })
--left
keymap("n", "<leader><Left>", "<cmd>wincmd h<cr>", { desc = "Move to left window" })
--right
keymap("n", "<leader><Right>", "<cmd>wincmd l<cr>", { desc = "Move to right window" })

--lsp
keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "LSP goto definition" })
keymap("n", "<leader>gD", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "LSP show references" })
keymap("n", "<leader>grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename all references in buffer" })
keymap("n", "<leader>ll", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "LSP show diagnostics" })

-- editor commands
keymap("n", "<A-Up>", "<cmd>m -2<cr>", { desc = "Move row 1 up" })
keymap("n", "<A-Down>", "<cmd>m +1<cr>", { desc = "Move row 1 down" })
keymap("x", "<A-Down>", "<cmd>'<,'>move-2<CR>gv=gv<cr>", { desc = "Move row 1 down" })

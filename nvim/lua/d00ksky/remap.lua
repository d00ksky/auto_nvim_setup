-- Leader key
vim.g.mapleader = " "

-- Basic navigation
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })

-- Better text movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better scrolling
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and restore cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better copy/paste
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Escape alternatives
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Alternative escape" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Format
vim.keymap.set("n", "<leader>f", function()
    if _G.nvim_mode == "learning" then
        vim.notify("Formatting disabled in Learning mode", vim.log.levels.WARN)
        return
    end
    vim.lsp.buf.format()
end, { desc = "Format buffer" })

-- Quick navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list" })

-- Search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })

-- Make executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Source file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source current file" })

-- === MODE SWITCHING ===
vim.keymap.set("n", "<leader>ml", "<cmd>LearningMode<CR>", { desc = "Switch to Learning mode" })
vim.keymap.set("n", "<leader>md", "<cmd>DevelopmentMode<CR>", { desc = "Switch to Development mode" })
vim.keymap.set("n", "<leader>mc", "<cmd>ClaudeMode<CR>", { desc = "Switch to Claude mode" })

-- === FILE NAVIGATION ===
-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find string under cursor" })

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer" })

-- Harpoon
vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<C-u>", function() require("harpoon.ui").nav_file(1) end, { desc = "Navigate to harpoon file 1" })
vim.keymap.set("n", "<C-i>", function() require("harpoon.ui").nav_file(2) end, { desc = "Navigate to harpoon file 2" })
vim.keymap.set("n", "<C-o>", function() require("harpoon.ui").nav_file(3) end, { desc = "Navigate to harpoon file 3" })
vim.keymap.set("n", "<C-p>", function() require("harpoon.ui").nav_file(4) end, { desc = "Navigate to harpoon file 4" })

-- === GIT ===
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })

-- === UTILITIES ===
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<CR>", { desc = "Toggle trouble diagnostics" })
vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode" })

-- === TERMINAL ===
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- === CLAUDE CODE INTEGRATION ===
vim.keymap.set("n", "<leader>cc", function()
    -- Toggle Claude mode and open terminal for Claude Code
    vim.cmd("ClaudeMode")
    vim.cmd("ToggleTerm")
end, { desc = "Activate Claude Code mode" })

-- Copy current file path to clipboard for Claude
vim.keymap.set("n", "<leader>cp", function()
    local filepath = vim.fn.expand("%:p")
    vim.fn.setreg("+", filepath)
    vim.notify("File path copied to clipboard: " .. filepath, vim.log.levels.INFO)
end, { desc = "Copy file path to clipboard" })

-- Copy current file content to clipboard for Claude
vim.keymap.set("n", "<leader>cf", function()
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    vim.fn.setreg("+", content)
    vim.notify("File content copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy file content to clipboard" })

-- Copy selection to clipboard for Claude
vim.keymap.set("v", "<leader>cs", function()
    vim.cmd('normal! gv"+y')
    vim.notify("Selection copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy selection to clipboard" })

-- Generate project context for Claude
vim.keymap.set("n", "<leader>ctx", function()
    local cmd = "find . -type f -name '*.py' -o -name '*.go' -o -name '*.js' -o -name '*.ts' -o -name '*.lua' | head -20 | xargs wc -l"
    local output = vim.fn.system(cmd)
    vim.fn.setreg("+", "Project structure:\n" .. output)
    vim.notify("Project context copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy project context to clipboard" })
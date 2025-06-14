-- Basic fugitive setup with helpful keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

-- Additional git keymaps for better workflow
vim.keymap.set("n", "<leader>gf", "<cmd>diffget //2<CR>", { desc = "Get diff from left (target branch)" })
vim.keymap.set("n", "<leader>gj", "<cmd>diffget //3<CR>", { desc = "Get diff from right (merge branch)" })

-- Git blame
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })

-- Git log
vim.keymap.set("n", "<leader>gl", "<cmd>Git log --oneline<CR>", { desc = "Git log" })

-- Git push/pull
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "Git pull" })

-- Git commit
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gC", "<cmd>Git commit --amend<CR>", { desc = "Git commit amend" })

-- Git add
vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<CR>", { desc = "Git add all" })
vim.keymap.set("n", "<leader>gA", "<cmd>Git add %<CR>", { desc = "Git add current file" })

-- Git checkout
vim.keymap.set("n", "<leader>go", "<cmd>Git checkout ", { desc = "Git checkout" })

-- Git status in split
vim.keymap.set("n", "<leader>gS", "<cmd>Git<CR><cmd>wincmd T<CR>", { desc = "Git status in new tab" })
-- Undotree
vim.g.undotree_WindowLayout = 2

-- Trouble
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
    trouble.setup {
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    group = true,
    padding = true,
    action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = {"<cr>", "<tab>"},
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = {"o"},
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = {"zM", "zm"},
        open_folds = {"zR", "zr"},
        toggle_fold = {"zA", "za"},
        previous = "k",
        next = "j"
    },
    indent_lines = true,
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    auto_jump = {"lsp_definitions"},
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = false
}
end

-- Zen Mode
local zenmode_ok, zenmode = pcall(require, "zen-mode")
if zenmode_ok then
    zenmode.setup {
    window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
        },
    },
    plugins = {
        options = {
            enabled = true,
            ruler = false,
            showcmd = false,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
            enabled = false,
            font = "+4",
        },
    },
}
end

-- Cloak (for hiding sensitive information)
local cloak_ok, cloak = pcall(require, 'cloak')
if cloak_ok then
    cloak.setup({
    enabled = true,
    cloak_character = '*',
    highlight_group = 'Comment',
    patterns = {
        {
            file_pattern = {
                ".env*",
                "wrangler.toml",
                ".dev.vars",
            },
            cloak_pattern = "=.+",
        },
    },
})
end

-- ToggleTerm
local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
if toggleterm_ok then
    toggleterm.setup{
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    }
}

    -- Function to create a terminal for Claude Code
    function _CLAUDE_TOGGLE()
        local Terminal = require('toggleterm.terminal').Terminal
    local claude_term = Terminal:new({
        cmd = "bash",
        dir = "git_dir",
        direction = "float",
        float_opts = {
            border = "double",
        },
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
            vim.cmd("startinsert!")
        end,
    })
    claude_term:toggle()
end

    vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>lua _CLAUDE_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Open Claude terminal"})
end

-- Neogen (documentation generator)
local neogen_ok, neogen = pcall(require, 'neogen')
if neogen_ok then
    neogen.setup {
    enabled = true,
    languages = {
        python = {
            template = {
                annotation_convention = "google_docstrings"
            }
        },
        go = {
            template = {
                annotation_convention = "godoc"
            }
        },
        javascript = {
            template = {
                annotation_convention = "jsdoc"
            }
        },
        typescript = {
            template = {
                annotation_convention = "jsdoc"
            }
        },
    }
}

    -- Neogen keymaps
    vim.keymap.set("n", "<leader>nf", "<cmd>Neogen func<CR>", { desc = "Generate function documentation" })
    vim.keymap.set("n", "<leader>nc", "<cmd>Neogen class<CR>", { desc = "Generate class documentation" })
    vim.keymap.set("n", "<leader>nt", "<cmd>Neogen type<CR>", { desc = "Generate type documentation" })
    vim.keymap.set("n", "<leader>nF", "<cmd>Neogen file<CR>", { desc = "Generate file documentation" })
end
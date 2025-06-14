-- Check if telescope is available
local ok, telescope = pcall(require, 'telescope')
if not ok then
    return
end

local builtin_ok, builtin = pcall(require, 'telescope.builtin')
if not builtin_ok then
    return
end

telescope.setup({
    defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
        path_display = { "truncate" },
        file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "__pycache__/",
            "%.pyc",
            "%.pyo",
            "%.cache/",
            ".venv/",
            "venv/",
            "env/",
            "%.egg-info/",
        },
        layout_config = {
            horizontal = {
                preview_width = 0.6,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-q>"] = "send_to_qflist",
                ["<C-l>"] = "complete_tag",
                ["<C-_>"] = "which_key", -- keys from pressing <C-/>
            },
            n = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-q>"] = "send_to_qflist",
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
})

-- Load extensions
telescope.load_extension('fzf')

-- Custom functions for better file finding
local function find_files_from_project_git_root()
    local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
    end
    local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
    end
    local opts = {}
    if is_git_repo() then
        opts = {
            cwd = get_git_root(),
        }
    end
    builtin.find_files(opts)
end

-- Override default find_files to use git root when available
vim.keymap.set("n", "<leader>ff", find_files_from_project_git_root, { desc = "Find files from git root" })
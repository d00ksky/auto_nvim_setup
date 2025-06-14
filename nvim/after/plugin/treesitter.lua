-- Check if treesitter is available
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
    return
end

configs.setup {
    ensure_installed = {
        "python",
        "go", 
        "javascript",
        "typescript",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "html",
        "css",
        "json",
        "yaml",
        "markdown",
        "bash",
        "rust"
    },
    
    sync_install = false,
    auto_install = true,
    
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    
    indent = {
        enable = true
    },
    
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
}
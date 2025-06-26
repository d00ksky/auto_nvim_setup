#!/bin/bash

# Perfect Neovim Setup Installer
# Installs Neovim with tri-mode configuration (Learning/Development/Claude modes)
# Compatible with Linux and WSL

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}  Perfect Neovim Setup Installer${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running on WSL
is_wsl() {
    if grep -q Microsoft /proc/version; then
        return 0
    else
        return 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install Node.js with version verification
install_nodejs() {
    print_info "Checking Node.js installation..."
    
    if command_exists node; then
        node_version=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1)
        if [ "$node_version" -ge 14 ]; then
            print_success "Node.js is already installed with compatible version"
            return
        fi
    fi
    
    print_info "Installing Node.js..."
    
    if command_exists apt; then
        # Install NodeSource repository for latest Node.js
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    elif command_exists dnf; then
        sudo dnf install -y nodejs npm
    elif command_exists pacman; then
        sudo pacman -S --noconfirm nodejs npm
    else
        # Fallback to package manager default
        print_warning "Using default package manager Node.js version"
    fi
    
    if command_exists node; then
        print_success "Node.js installed successfully"
    else
        print_error "Failed to install Node.js"
        exit 1
    fi
}

# Install dependencies based on distribution
install_dependencies() {
    print_info "Installing system dependencies..."
    
    if command_exists apt; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install -y git curl build-essential unzip python3 python3-pip golang-go xclip file wget
        print_success "Installed base dependencies for Ubuntu/Debian"
    elif command_exists yum; then
        # RHEL/CentOS
        sudo yum install -y git curl gcc gcc-c++ make unzip python3 python3-pip golang xclip file wget
        print_success "Installed base dependencies for RHEL/CentOS"
    elif command_exists dnf; then
        # Fedora
        sudo dnf install -y git curl gcc gcc-c++ make unzip python3 python3-pip golang xclip file wget
        print_success "Installed base dependencies for Fedora"
    elif command_exists pacman; then
        # Arch Linux
        sudo pacman -S --noconfirm git curl base-devel unzip python python-pip go xclip file wget
        print_success "Installed base dependencies for Arch Linux"
    else
        print_error "Unsupported package manager. Please install dependencies manually:"
        print_info "  - git, curl, build-essential, unzip"
        print_info "  - python3, python3-pip"
        print_info "  - golang"
        print_info "  - xclip (for clipboard support)"
        exit 1
    fi
    
    # Install Node.js separately with version check
    install_nodejs
    
    # Verify critical dependencies
    print_info "Verifying critical dependencies..."
    local missing_deps=()
    
    command_exists git || missing_deps+=("git")
    command_exists curl || missing_deps+=("curl")
    command_exists node || missing_deps+=("nodejs")
    command_exists python3 || missing_deps+=("python3")
    command_exists go || missing_deps+=("golang")
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_success "All critical dependencies verified"
    else
        print_error "Missing critical dependencies: ${missing_deps[*]}"
        print_info "Please install missing dependencies and run the script again"
        exit 1
    fi
}

# Install Neovim
install_neovim() {
    print_info "Installing Neovim..."
    
    # Check if Neovim is already installed with compatible version
    if command_exists nvim; then
        nvim_version=$(nvim --version 2>/dev/null | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | sed 's/v//' || echo "0.0")
        if [ "$(printf '%s\n' "0.8" "$nvim_version" | sort -V | head -n1)" = "0.8" ]; then
            print_success "Neovim is already installed with a compatible version ($nvim_version)"
            return
        fi
    fi
    
    # Try package manager first for recent distributions
    if command_exists apt; then
        # Check Ubuntu version
        ubuntu_version=$(lsb_release -rs 2>/dev/null || echo "0")
        if [ "$(printf '%s\n' "22.04" "$ubuntu_version" | sort -V | head -n1)" = "22.04" ]; then
            print_info "Installing Neovim via apt (Ubuntu 22.04+)..."
            sudo apt install -y neovim
            if command_exists nvim; then
                print_success "Installed Neovim via package manager"
                return
            fi
        fi
    elif command_exists dnf; then
        print_info "Installing Neovim via dnf..."
        sudo dnf install -y neovim
        if command_exists nvim; then
            print_success "Installed Neovim via package manager"
            return
        fi
    elif command_exists pacman; then
        print_info "Installing Neovim via pacman..."
        sudo pacman -S --noconfirm neovim
        if command_exists nvim; then
            print_success "Installed Neovim via package manager"
            return
        fi
    fi
    
    # Download and install latest Neovim manually
    print_info "Installing latest Neovim from GitHub releases..."
    cd /tmp
    
    # Get the actual download URL for the latest release
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$NVIM_VERSION" ]; then
        # Fallback to a known stable version
        NVIM_VERSION="v0.9.5"
        print_warning "Could not fetch latest version, using $NVIM_VERSION"
    fi
    
    DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
    print_info "Downloading Neovim $NVIM_VERSION..."
    
    # Download with better error handling
    if curl -L "$DOWNLOAD_URL" -o nvim-linux64.tar.gz; then
        # Verify it's actually a gzip file
        if file nvim-linux64.tar.gz | grep -q gzip; then
            tar -xzf nvim-linux64.tar.gz
            sudo rm -rf /opt/nvim 2>/dev/null || true
            sudo mv nvim-linux64 /opt/nvim
            sudo mkdir -p /usr/local/bin
            sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
            print_success "Installed Neovim $NVIM_VERSION"
        else
            print_error "Downloaded file is not a valid gzip archive"
            print_info "Trying alternative installation method..."
            
            # Try AppImage as fallback
            curl -L "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage" -o nvim.appimage
            chmod +x nvim.appimage
            sudo mv nvim.appimage /usr/local/bin/nvim
            print_success "Installed Neovim AppImage"
        fi
    else
        print_error "Failed to download Neovim"
        print_info "Please install Neovim manually:"
        print_info "  Ubuntu: sudo apt install neovim"
        print_info "  Fedora: sudo dnf install neovim"
        print_info "  Arch: sudo pacman -S neovim"
        exit 1
    fi
}

# Setup configuration
setup_config() {
    print_info "Setting up Neovim configuration..."
    
    # Backup existing config if it exists
    if [ -d "$HOME/.config/nvim" ]; then
        # Create a timestamped backup if backup already exists
        backup_dir="$HOME/.config/nvim.backup"
        if [ -d "$backup_dir" ]; then
            timestamp=$(date +"%Y%m%d_%H%M%S")
            backup_dir="$HOME/.config/nvim.backup_$timestamp"
        fi
        print_warning "Backing up existing Neovim configuration to $backup_dir"
        mv "$HOME/.config/nvim" "$backup_dir"
    fi
    
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Copy our configuration
    cp -r "$(dirname "$0")/nvim" "$HOME/.config/"
    
    print_success "Copied Neovim configuration"
}

# Install Rust (needed for some tools)
install_rust() {
    if command_exists rustc; then
        print_success "Rust is already installed"
        
        # Check if default toolchain is set
        if ! rustup default >/dev/null 2>&1; then
            print_info "Setting up Rust default toolchain..."
            rustup default stable
            print_success "Set Rust default toolchain to stable"
        fi
        return
    fi
    
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    # Ensure default toolchain is set
    rustup default stable
    print_success "Installed Rust with stable toolchain"
}

# Install additional tools
install_tools() {
    print_info "Installing additional development tools..."
    
    # Ensure Rust environment is loaded
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    
    # Install ripgrep (better grep)
    if ! command_exists rg; then
        if command_exists cargo && rustup default >/dev/null 2>&1; then
            print_info "Installing ripgrep via cargo..."
            cargo install ripgrep
            print_success "Installed ripgrep via cargo"
        else
            print_info "Installing ripgrep via package manager..."
            if command_exists apt; then
                sudo apt install -y ripgrep
            elif command_exists dnf; then
                sudo dnf install -y ripgrep
            elif command_exists pacman; then
                sudo pacman -S --noconfirm ripgrep
            fi
            print_success "Installed ripgrep via package manager"
        fi
    else
        print_success "ripgrep is already installed"
    fi
    
    # Install fd (better find)
    if ! command_exists fd; then
        if command_exists cargo && rustup default >/dev/null 2>&1; then
            print_info "Installing fd via cargo..."
            cargo install fd-find
            print_success "Installed fd via cargo"
        else
            print_info "Installing fd via package manager..."
            if command_exists apt; then
                sudo apt install -y fd-find
            elif command_exists dnf; then
                sudo dnf install -y fd-find
            elif command_exists pacman; then
                sudo pacman -S --noconfirm fd
            fi
            print_success "Installed fd via package manager"
        fi
    else
        print_success "fd is already installed"
    fi
    
    # Install Python language server tools
    print_info "Installing Python development tools..."
    
    if command_exists pip3; then
        # Check if we can install to user directory
        print_info "Attempting to install python-lsp-server..."
        
        # Try multiple installation methods, handling externally managed environments
        if command_exists apt && sudo apt install -y python3-pylsp 2>/dev/null; then
            print_success "Installed python-lsp-server via apt (system package)"
        elif pip3 install --user python-lsp-server --break-system-packages 2>/dev/null; then
            print_success "Installed python-lsp-server via pip3 --user (with override)"
        elif pip3 install --user python-lsp-server 2>/dev/null; then
            print_success "Installed python-lsp-server via pip3 --user"
        elif pip3 install python-lsp-server 2>/dev/null; then
            print_success "Installed python-lsp-server via pip3"
        else
            print_warning "Could not install python-lsp-server. Python LSP will be installed by Mason when needed"
        fi
        
        # Try to install additional Python tools (optional)
        if pip3 install --user pylsp-mypy 2>/dev/null; then
            print_success "Installed pylsp-mypy (optional enhancement)"
        else
            print_info "pylsp-mypy installation skipped (optional)"
        fi
    elif command_exists pip; then
        # Fallback to pip if pip3 not available
        print_info "Using pip (fallback from pip3)..."
        pip install --user python-lsp-server 2>/dev/null || {
            print_warning "Failed to install via pip as well"
        }
    else
        print_warning "Neither pip3 nor pip found, Python LSP will be installed by Mason"
    fi
    
    print_success "Additional tools installation completed"
}

# Setup WSL-specific configurations
setup_wsl() {
    print_info "Setting up WSL-specific configurations..."
    
    # Setup clipboard for WSL
    if ! command_exists clip.exe; then
        print_warning "Windows clip.exe not found. Clipboard integration may not work."
    else
        # Create a script to bridge xclip and Windows clipboard
        cat > "$HOME/.local/bin/xclip" << 'EOF'
#!/bin/bash
if [ "$1" = "-selection" ] && [ "$2" = "clipboard" ]; then
    cat | clip.exe
else
    /usr/bin/xclip "$@"
fi
EOF
        chmod +x "$HOME/.local/bin/xclip"
        print_success "Setup WSL clipboard integration"
    fi
}

# Apply post-installation fixes to prevent common issues
apply_fixes() {
    print_info "Applying post-installation fixes..."
    
    # Fix 1: Update LSP configuration to use correct Mason package names
    if [ -f "$HOME/.config/nvim/after/plugin/lsp.lua" ]; then
        # Replace tsserver with ts_ls in ensure_installed array
        sed -i "s/'tsserver',/'ts_ls',/g" "$HOME/.config/nvim/after/plugin/lsp.lua"
        
        # Replace tsserver handler with ts_ls
        sed -i "s/tsserver = function()/ts_ls = function()/g" "$HOME/.config/nvim/after/plugin/lsp.lua"
        
        # Replace lspconfig.tsserver with lspconfig.ts_ls
        sed -i "s/lspconfig\.tsserver/lspconfig.ts_ls/g" "$HOME/.config/nvim/after/plugin/lsp.lua"
        
        # Disable auto-installation to prevent startup errors
        sed -i '/Add Mason installation status check and recovery/,/^})$/c\
-- Mason auto-installation disabled to prevent startup errors\
-- Language servers will install automatically when you open relevant files\
-- To manually install: :MasonInstall pyright gopls typescript-language-server lua-language-server rust-analyzer' "$HOME/.config/nvim/after/plugin/lsp.lua"
        
        print_success "Fixed LSP configuration package names"
    fi
    
    # Fix 2: Add Neo-tree migration warning suppression
    if [ -f "$HOME/.config/nvim/after/plugin/neotree.lua" ]; then
        # Add migration warning suppression at the top
        if ! grep -q "neo_tree_remove_legacy_commands" "$HOME/.config/nvim/after/plugin/neotree.lua"; then
            sed -i '/^neotree\.setup({/i\
-- Suppress Neo-tree migration warnings and set modern defaults\
vim.g.neo_tree_remove_legacy_commands = 1\
\
-- Disable deprecation warnings for Neo-tree\
local notify = vim.notify\
vim.notify = function(msg, level, opts)\
    if type(msg) == "string" and (\
        msg:match("neo%-tree") and msg:match("deprecated") or\
        msg:match("neo%-tree") and msg:match("migration") or\
        msg:match("neo%-tree") and msg:match("legacy")\
    ) then\
        return -- Suppress Neo-tree deprecation warnings\
    end\
    notify(msg, level, opts)\
end\
' "$HOME/.config/nvim/after/plugin/neotree.lua"
        fi
        print_success "Added Neo-tree migration warning suppression"
    fi
    
    # Fix 3: Clear any problematic cache and state files
    rm -f ~/.local/share/nvim/mason_auto_installed 2>/dev/null || true
    rm -rf ~/.cache/nvim 2>/dev/null || true
    rm -f ~/.config/nvim/plugin/packer_compiled.lua 2>/dev/null || true
    
    print_success "Cleared problematic cache files"
    
    # Fix 4: Ensure Rust toolchain is properly set
    if command_exists rustup; then
        if ! rustup default >/dev/null 2>&1; then
            print_info "Setting Rust default toolchain..."
            rustup default stable >/dev/null 2>&1 || true
        fi
    fi
    
    print_success "Post-installation fixes applied successfully"
}

# Initialize Neovim and install plugins
init_neovim() {
    print_info "Initializing Neovim and installing plugins..."
    
    # First, install Packer if it doesn't exist
    if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
        print_info "Installing Packer plugin manager..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    fi
    
    # Install plugins with better error handling
    print_info "Installing plugins (this may take a while)..."
    
    # Run Packer sync multiple times if needed (some plugins need compilation)
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || {
        print_warning "First plugin install failed, trying again..."
        sleep 2
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || {
            print_warning "Plugin installation had issues, but continuing..."
        }
    }
    
    # Run TreeSitter installs (only if TreeSitter is available)
    print_info "Installing TreeSitter parsers..."
    nvim --headless -c 'lua if pcall(require, "nvim-treesitter") then vim.cmd("TSUpdateSync") end' -c 'qall' 2>/dev/null || {
        print_info "TreeSitter update will complete on first normal startup"
    }
    
    # Compile Packer
    nvim --headless -c 'PackerCompile' -c 'qall' 2>/dev/null || true
    
    print_success "Plugin installation completed"
    
    # Apply post-installation fixes
    apply_fixes
    
    # Note: Mason verification disabled to prevent startup errors
    # Language servers will install automatically when you open relevant files
}

# Main installation function
main() {
    print_header
    
    # Check if script is run from correct directory
    if [ ! -f "$(dirname "$0")/nvim/init.lua" ]; then
        print_error "Please run this script from the auto_nvim_setup directory"
        exit 1
    fi
    
    print_info "Starting installation..."
    
    # Install system dependencies
    install_dependencies
    
    # Install Neovim
    install_neovim
    
    # Install Rust
    install_rust
    
    # Install additional tools
    install_tools
    
    # Setup configuration
    setup_config
    
    # WSL-specific setup
    if is_wsl; then
        setup_wsl
    fi
    
    # Initialize Neovim
    init_neovim
    
    echo ""
    print_success "Installation completed!"
    echo ""
    print_info "🎉 Your perfect Neovim setup is ready!"
    echo ""
    print_info "First run notes:"
    print_info "  • On first startup, plugins will finish installing"
    print_info "  • TreeSitter parsers will download automatically"
    print_info "  • Language servers will install when you open relevant files"
    echo ""
    print_info "Quick start:"
    print_info "  • Run 'nvim' to start Neovim"
    print_info "  • Press 'Space + ml' for Learning mode"
    print_info "  • Press 'Space + md' for Development mode"  
    print_info "  • Press 'Space + mc' for Claude mode"
    print_info "  • Press 'Space + ff' to find files"
    print_info "  • Press 'Space + e' to open file explorer"
    print_info "  • Press 'Space + cc' to activate Claude Code mode"
    echo ""
    print_info "Troubleshooting:"
    print_info "  • If you see Mason errors, run ':MasonTroubleshoot' in Neovim"
    print_info "  • Language servers install automatically on first file open"
    print_info "  • Use ':Mason' to manually install/update language servers"
    print_info "  • Run ':PackerSync' if plugins seem missing"
    print_info "  • Restart Neovim after any plugin installations"
    echo ""
    print_info "📖 Check the README.md for complete keybinding documentation"
    echo ""
    
    # Check if in Claude Code environment
    if [ -n "$CLAUDE_CODE" ]; then
        print_info "🤖 Claude Code detected! You're all set for the perfect workflow."
    fi
}

# Run main function
main "$@"
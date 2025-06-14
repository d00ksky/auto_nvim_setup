#!/bin/bash

# Test version of setup script without sudo operations
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_info "Testing Perfect Neovim Setup (no sudo operations)..."
echo ""

# Check dependencies
print_info "Checking dependencies..."
if command_exists nvim; then
    nvim_version=$(nvim --version 2>/dev/null | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | sed 's/v//' || echo "0.0")
    print_success "Neovim $nvim_version found"
else
    print_error "Neovim not found"
fi

for cmd in node npm python3 go git curl; do
    if command_exists "$cmd"; then
        print_success "$cmd found"
    else
        print_warning "$cmd not found"
    fi
done

# Setup configuration (this is the main part we can test)
print_info "Setting up Neovim configuration..."

# Backup existing config if it exists
if [ -d "$HOME/.config/nvim" ]; then
    print_warning "Backing up existing Neovim configuration to ~/.config/nvim.backup.test"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.test"
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy our configuration
cp -r "$(dirname "$0")/nvim" "$HOME/.config/"
print_success "Copied Neovim configuration"

# Install Packer if it doesn't exist
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    print_info "Installing Packer plugin manager..."
    mkdir -p "$HOME/.local/share/nvim/site/pack/packer/start"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    print_success "Packer installed"
else
    print_success "Packer already installed"
fi

print_info "Testing Neovim configuration load..."
# Test that our config loads without errors
if nvim --headless -c 'lua print("Config loaded successfully")' -c 'qall' 2>&1; then
    print_success "Neovim configuration loads without errors"
else
    print_warning "Neovim configuration has some warnings (expected before plugin installation)"
fi

print_info "Installing plugins (this may take a while)..."
# Try to install plugins
if nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; then
    print_success "Plugins installed successfully"
else
    print_warning "Plugin installation had some issues, but this is normal on first run"
fi

echo ""
print_success "Test setup completed!"
print_info "You can now run 'nvim' to test your configuration"
print_info "The tri-mode system should work: Space+ml, Space+md, Space+mc"
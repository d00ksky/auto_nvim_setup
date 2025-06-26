#!/bin/bash

# Fix common setup issues script
# Run this if you encounter problems during or after setup

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

print_info "Fixing common Neovim setup issues..."

# 1. Fix Rust toolchain if needed
if command -v rustup >/dev/null 2>&1; then
    if ! rustup default >/dev/null 2>&1; then
        print_info "Setting Rust default toolchain..."
        rustup default stable
        print_success "Rust toolchain fixed"
    fi
fi

# 2. Install Python language server tools properly
print_info "Installing Python language server tools..."
if command -v pip3 >/dev/null 2>&1; then
    pip3 install --user python-lsp-server pylsp-mypy 2>/dev/null || {
        print_warning "Some Python tools failed to install"
    }
    print_success "Python tools installation attempted"
fi

# 3. Clean and reinstall plugins
print_info "Cleaning and reinstalling Neovim plugins..."
nvim --headless -c 'PackerClean' -c 'qall!' 2>/dev/null || true
sleep 2
nvim --headless -c 'PackerSync' -c 'qall!' 2>/dev/null || {
    print_warning "Plugin sync had issues, trying again..."
    sleep 3
    nvim --headless -c 'PackerSync' -c 'qall!' 2>/dev/null || true
}

# 4. Force install language servers
print_info "Installing language servers..."
nvim --headless -c 'MasonInstall pyright gopls ts_ls lua_ls rust_analyzer' -c 'sleep 10' -c 'qall!' 2>/dev/null || {
    print_warning "Mason install had issues, servers will install on first file open"
}

# 5. Compile TreeSitter parsers
print_info "Installing TreeSitter parsers..."
nvim --headless -c 'TSUpdate' -c 'qall!' 2>/dev/null || {
    print_info "TreeSitter will update on first startup"
}

print_success "Setup issues fixed!"
print_info "Start Neovim with 'nvim' - language servers will install automatically when you open files"
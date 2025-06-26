# Changelog

All notable changes and improvements to the Perfect Neovim Setup.

## [v2.0.0] - 2024-12-26 - Enhanced Reliability Update

### 🔧 Major Fixes & Improvements

#### Mason Language Server Issues
- **Fixed**: "Cannot find package tsserver" errors by updating to correct package name `ts_ls`
- **Fixed**: Mason auto-installation causing startup errors - now installs on-demand
- **Added**: Comprehensive error handling and fallback mechanisms
- **Added**: `:MasonTroubleshoot` command for diagnostics

#### Python LSP Installation
- **Fixed**: "externally-managed-environment" errors on modern Ubuntu/Debian
- **Added**: Multiple installation methods with fallbacks:
  1. System packages (apt install python3-pylsp)
  2. pip with `--break-system-packages` override
  3. Regular pip installation
  4. Mason fallback

#### Rust Toolchain Issues
- **Fixed**: "rustup could not choose a version of cargo to run" errors
- **Added**: Automatic `rustup default stable` setup
- **Improved**: Rust environment loading in installation scripts

#### Neo-tree Migration Warnings
- **Fixed**: Migration and deprecation warnings on startup
- **Added**: Warning suppression system
- **Updated**: Configuration to modern Neo-tree format

#### Backup System
- **Fixed**: "Directory not empty" errors when backups already exist
- **Added**: Timestamped backup creation (nvim.backup_YYYYMMDD_HHMMSS)

### 🚀 Enhanced Setup Script

#### New Features
- **Added**: `apply_fixes()` function with comprehensive post-installation fixes
- **Added**: Automatic package name corrections
- **Added**: Cache cleanup and state reset
- **Improved**: Dependency verification with multiple package managers
- **Enhanced**: Error messaging and troubleshooting guidance

#### Fix Scripts
- **Added**: `fix_setup_issues.sh` - Comprehensive setup problem resolver
- **Added**: `fix_neotree.sh` - Neo-tree migration warning fixer
- **Added**: `reset_mason.sh` - Complete Mason reset utility

### 📚 Documentation Updates

#### README Enhancements
- **Updated**: Language server information (tsserver → TypeScript Language Server)
- **Added**: Comprehensive troubleshooting section with all common issues
- **Added**: Solutions for externally-managed Python environments
- **Added**: Rust toolchain troubleshooting
- **Added**: Reference to included fix scripts

#### New Documentation
- **Added**: This CHANGELOG.md with detailed version history
- **Updated**: Installation instructions with troubleshooting info

### 🔄 Configuration Improvements

#### LSP Configuration
- **Updated**: Package names to current Mason standards
- **Disabled**: Problematic auto-installation on startup
- **Added**: Better error handling for missing dependencies
- **Enhanced**: Language server setup with dependency checks

#### Neo-tree Configuration
- **Added**: Migration warning suppression
- **Updated**: Modern configuration format
- **Enhanced**: Error handling and graceful fallbacks

### 🛠️ Development Experience

#### Error Prevention
- **Eliminated**: Startup error messages
- **Improved**: Clean Neovim initialization
- **Enhanced**: Language server installation reliability
- **Added**: Graceful fallbacks for all components

#### Troubleshooting Tools
- **Added**: `:MasonTroubleshoot` command for system diagnostics
- **Added**: `:MasonResetAutoInstall` command for resetting state
- **Included**: Multiple fix scripts for different issues

### 🧪 Testing & Reliability

#### Compatibility
- **Tested**: Ubuntu 22.04+ with externally-managed Python
- **Verified**: WSL 1 & 2 compatibility
- **Confirmed**: Multiple package manager support (apt, dnf, pacman)
- **Validated**: Rust installation and toolchain setup

#### Error Handling
- **Improved**: Graceful handling of network issues
- **Enhanced**: Fallback mechanisms for all installations
- **Added**: Comprehensive error reporting
- **Implemented**: Retry logic for failed operations

---

## [v1.0.0] - Initial Release

### ✨ Features
- Perfect Neovim setup with tri-mode system
- Comprehensive language server support
- Claude Code integration
- Automated installation script
- Rich plugin ecosystem

### 🎯 Tri-Mode System
- Learning Mode (minimal assistance)
- Development Mode (full LSP)
- Claude Mode (optimized for AI collaboration)

### 🛠️ Language Support
- Python, Go, JavaScript/TypeScript, Lua, Rust
- Automatic language server installation
- Intelligent completion and diagnostics

---

*This changelog follows [Keep a Changelog](https://keepachangelog.com/) format.*
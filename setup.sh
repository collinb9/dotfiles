#!/usr/bin/env bash
#
# Dotfiles Setup Script
# Enhanced with safety, profiles, and distribution support
#

set -euo pipefail

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
PROFILE="full"  # full or minimal
SKIP_TOOLS=false
SKIP_DESKTOP=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-tools)
            SKIP_TOOLS=true
            shift
            ;;
        --skip-desktop)
            SKIP_DESKTOP=true
            shift
            ;;
        minimal|full)
            PROFILE="$1"
            shift
            ;;
        *)
            log_error "Unknown option: $1" 2>/dev/null || echo "Error: Unknown option: $1"
            echo "Usage: $0 [minimal|full] [--skip-tools] [--skip-desktop]"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Source user configuration if it exists
if [[ -f "$DOTFILES_DIR/config/user.conf" ]]; then
    source "$DOTFILES_DIR/config/user.conf"
else
    # Use defaults if no user.conf
    GIT_WORK_DIR="${GIT_WORK_DIR:-$HOME/Work}"
    WALLPAPER_PATH="${WALLPAPER_PATH:-$HOME/Pictures/wallpapers/arch.jpg}"
fi

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup existing file/directory if it's not a symlink
backup_existing() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        log_info "Backed up: $(basename "$target") → $BACKUP_DIR/"
    fi
}

# Safe symlink creation with idempotency
safe_link() {
    local source="$1"
    local target="$2"
    
    # Skip if already correctly linked
    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        return 0
    fi
    
    # Backup if real file/directory exists
    backup_existing "$target"
    
    # Remove broken symlink if exists
    [[ -L "$target" ]] && rm "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    log_info "Linked: $(basename "$source") → $target"
}

# Configure tmux prefix key interactively
configure_tmux_prefix() {
    local key="${TMUX_PREFIX_KEY:-}"
    local user_conf="$DOTFILES_DIR/config/user.conf"

    # Determine the prefix key
    if [[ -n "$key" ]]; then
        log_info "Tmux prefix key already set: C-$key"
    elif [[ ! -t 0 ]]; then
        key="b"
        log_info "Non-interactive mode, using default tmux prefix: C-$key"
    else
        echo -ne "${GREEN}[INPUT]${NC} Tmux prefix key: C-"
        read -r -n 1 key
        echo ""
        key="${key:-b}"
        log_info "Tmux prefix key set to: C-$key"
    fi

    # Save to user.conf if not already there
    if ! grep -q '^TMUX_PREFIX_KEY=' "$user_conf" 2>/dev/null; then
        if [[ ! -f "$user_conf" ]]; then
            cp "$DOTFILES_DIR/config/user.conf.example" "$user_conf"
        fi
        echo "TMUX_PREFIX_KEY=\"$key\"" >> "$user_conf"
    fi

    # Generate ~/.tmux.prefix.conf
    cat > "$HOME/.tmux.prefix.conf" <<EOF
set -g prefix C-$key
unbind C-b
bind C-$key send-prefix
EOF
    log_info "Generated ~/.tmux.prefix.conf (prefix: C-$key)"
}

# Detect Linux distribution
detect_distro() {
    if command -v pacman >/dev/null 2>&1; then
        echo "arch"
    elif command -v apt >/dev/null 2>&1; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Install packages based on distribution
install_packages() {
    local distro
    distro=$(detect_distro)
    
    case "$distro" in
        arch)
            log_info "Arch Linux detected - assuming packages already managed"
            # Arch users typically manage packages themselves
            ;;
        debian)
            if [[ -f "$DOTFILES_DIR/config/packages/debian.txt" ]]; then
                log_info "Debian/Ubuntu detected - installing essential packages"
                sudo apt update
                # shellcheck disable=SC2046
                sudo apt install -y $(grep -v '^#' "$DOTFILES_DIR/config/packages/debian.txt" | tr '\n' ' ')
            fi
            ;;
        *)
            log_warn "Unknown distribution - please install packages manually"
            ;;
    esac
}

# Install Rust-based tools via cargo
install_rust_tools() {
    log_info "Installing Rust-based tools..."
    
    # Check if cargo is available
    if ! command -v cargo >/dev/null 2>&1; then
        log_warn "Cargo not found. Installing rustup..."
        if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
            # shellcheck disable=SC1091
            source "$HOME/.cargo/env"
        else
            log_error "Failed to install rustup. Skipping Rust tools."
            return 1
        fi
    fi
    
    # Install tools with existence checks
    local rust_tools=("uv" "cfn-lsp-extra" "stylua" "tombi")
    for tool in "${rust_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_info "$tool already installed, skipping"
        else
            log_info "Installing $tool via cargo..."
            cargo install "$tool" || log_warn "Failed to install $tool"
        fi
    done
}

# Install Python tools via pipx
install_python_tools() {
    log_info "Installing Python tools..."
    
    # Ensure pip is available
    if ! command -v pip3 >/dev/null 2>&1; then
        log_error "pip3 not found. Install Python first."
        return 1
    fi
    
    # Install pipx for isolated tool installation
    if ! command -v pipx >/dev/null 2>&1; then
        log_info "Installing pipx..."
        pip3 install --user pipx
        pipx ensurepath
    fi
    
    # Install tools via pipx
    local python_tools=("cfn-lint" "beautysh")
    for tool in "${python_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_info "$tool already installed, skipping"
        else
            log_info "Installing $tool via pipx..."
            pipx install "$tool" || log_warn "Failed to install $tool"
        fi
    done
    
    # Install ruff via pipx if not in system packages (Debian fallback)
    if ! command -v ruff >/dev/null 2>&1; then
        log_info "Installing ruff via pipx (not in system packages)..."
        pipx install ruff || log_warn "Failed to install ruff"
    fi
}

# Install Node.js tools via npm
install_node_tools() {
    log_info "Installing Node.js tools..."
    
    # Check if npm is available
    if ! command -v npm >/dev/null 2>&1; then
        log_warn "npm not found. Install Node.js first or run with --skip-tools"
        return 0
    fi
    
    # Install global npm tools
    local node_tools=("mcp-hub" "prettierd" "eslint_d")
    for tool in "${node_tools[@]}"; do
        if npm list -g "$tool" >/dev/null 2>&1; then
            log_info "$tool already installed globally, skipping"
        else
            log_info "Installing $tool via npm..."
            npm install -g "$tool" || log_warn "Failed to install $tool"
        fi
    done
}

# Install opencode npm dependencies
install_opencode_deps() {
    log_info "Installing opencode dependencies..."
    
    local opencode_dir="$DOTFILES_DIR/.config/opencode"
    if [[ -f "$opencode_dir/package.json" ]]; then
        if command -v npm >/dev/null 2>&1; then
            log_info "Running npm install in $opencode_dir..."
            (cd "$opencode_dir" && npm install) || log_warn "Failed to install opencode deps"
        else
            log_warn "npm not found, skipping opencode dependencies"
        fi
    else
        log_info "No opencode package.json found, skipping"
    fi
}

# Core configuration (shell, git, nvim)
install_core_configs() {
    log_info "Installing core configurations..."
    
    # nvim
    safe_link "$DOTFILES_DIR/.config/nvim/" "$HOME/.config/nvim"
    
    # tmux
    safe_link "$DOTFILES_DIR/.config/tmux/" "$HOME/.config/tmux"

    # ruff
    safe_link "$DOTFILES_DIR/.config/ruff/" "$HOME/.config/ruff"
    
    # git
    safe_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    safe_link "$DOTFILES_DIR/default.gitconfig" "$HOME/default.gitconfig"
    safe_link "$DOTFILES_DIR/work.gitconfig" "$HOME/work.gitconfig"
    backup_existing "$HOME/.git_template"
    safe_link "$DOTFILES_DIR/.git_template" "$HOME/.git_template"
    chmod +x "$HOME/.git_template/hooks/"* 2>/dev/null || true
    
    # zsh
    safe_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    safe_link "$DOTFILES_DIR/.config/zsh/" "$HOME/.config/zsh"
    
    # bin scripts
    safe_link "$DOTFILES_DIR/bin/" "$HOME/bin"
    chmod u+x "$HOME/bin/"** 2>/dev/null || true
    
    # misc rc files
    safe_link "$DOTFILES_DIR/.inputrc" "$HOME/.inputrc"
    safe_link "$DOTFILES_DIR/.psqlrc" "$HOME/.psqlrc"
    
    # pylint
    safe_link "$DOTFILES_DIR/.config/pylintrc" "$HOME/.config/pylintrc"
    
    # cfn-lint
    safe_link "$DOTFILES_DIR/.cfnlintrc" "$HOME/.cfnlintrc"
}

# Development tool configurations (useful on any system including WSL2/servers)
install_dev_configs() {
    log_info "Installing development tool configurations..."

    # CLI tools
    safe_link "$DOTFILES_DIR/.config/bat/" "$HOME/.config/bat"
    safe_link "$DOTFILES_DIR/.config/curl/" "$HOME/.config/curl"
    safe_link "$DOTFILES_DIR/.config/ranger/" "$HOME/.config/ranger"
    safe_link "$DOTFILES_DIR/.config/htop/" "$HOME/.config/htop"

    # dev tools
    safe_link "$DOTFILES_DIR/.config/opencode/" "$HOME/.config/opencode"
    safe_link "$DOTFILES_DIR/.config/uv/" "$HOME/.config/uv"

    # vim
    backup_existing "$HOME/.vim"
    safe_link "$DOTFILES_DIR/.vim" "$HOME/.vim"

    # screenrc
    safe_link "$DOTFILES_DIR/.screenrc" "$HOME/.screenrc"

    # agent tools
    safe_link "$DOTFILES_DIR/.claude" "$HOME/.claude"
    safe_link "$DOTFILES_DIR/.agents" "$HOME/.agents"
    safe_link "$DOTFILES_DIR/.pi" "$HOME/.pi"
    safe_link "$DOTFILES_DIR/.omp" "$HOME/.omp"
}

# Desktop/GUI configurations (X11, window managers, terminals)
install_desktop_configs() {
    log_info "Installing desktop configurations..."

    safe_link "$DOTFILES_DIR/.config/alacritty/" "$HOME/.config/alacritty"
    safe_link "$DOTFILES_DIR/.config/awesome/" "$HOME/.config/awesome"
    safe_link "$DOTFILES_DIR/.config/picom/" "$HOME/.config/picom"
    safe_link "$DOTFILES_DIR/.config/polybar/" "$HOME/.config/polybar"
    safe_link "$DOTFILES_DIR/.config/rofi/" "$HOME/.config/rofi"
    safe_link "$DOTFILES_DIR/.config/gtk-3.0/" "$HOME/.config/gtk-3.0"
    safe_link "$DOTFILES_DIR/.config/stockfish_socket_client/" "$HOME/.config/stockfish_socket_client"
    safe_link "$DOTFILES_DIR/.xinitrc" "$HOME/.xinitrc"
}

# Validation
validate_setup() {
    log_info "Validating setup..."
    
    local broken_links=()
    while IFS= read -r -d '' link; do
        if [[ ! -e "$link" ]]; then
            broken_links+=("$link")
        fi
    done < <(find "$HOME" -maxdepth 2 -type l -print0 2>/dev/null)
    
    if [[ ${#broken_links[@]} -gt 0 ]]; then
        log_warn "Found broken symlinks (may be expected):"
        printf '%s\n' "${broken_links[@]}"
    fi
}

# Main installation flow
main() {
    echo ""
    log_info "Dotfiles Setup - Profile: $PROFILE"
    echo ""
    
    # Check if running from correct directory
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi
    
    # Install packages if needed
    install_packages

    # Configure tmux prefix key
    configure_tmux_prefix

    # Install configurations based on profile
    case "$PROFILE" in
        minimal)
            log_info "Installing MINIMAL profile (shell + git + nvim only)"
            install_core_configs
            ;;
        full|*)
            log_info "Installing FULL profile (all configurations)"

            # Install additional tools unless skipped
            if [[ "$SKIP_TOOLS" == "false" ]]; then
                install_rust_tools
                install_python_tools
                install_node_tools
                install_opencode_deps
            else
                log_info "Skipping additional tool installation (--skip-tools)"
            fi

            # Install all configurations
            install_core_configs
            install_dev_configs

            if [[ "$SKIP_DESKTOP" == "false" ]]; then
                install_desktop_configs
            else
                log_info "Skipping desktop/GUI configurations (--skip-desktop)"
            fi
            ;;
    esac
    
    # Validate
    validate_setup
    
    # Summary
    echo ""
    log_info "Setup complete!"
    if [[ -d "$BACKUP_DIR" ]]; then
        log_info "Backups saved to: $BACKUP_DIR"
    fi
    
    # Tool installation summary
    if [[ "$SKIP_TOOLS" == "false" && "$PROFILE" == "full" ]]; then
        echo ""
        log_info "Additional tools installed:"
        command -v uv >/dev/null && echo "  ✓ uv (Python package manager)"
        command -v ruff >/dev/null && echo "  ✓ ruff (Python linter/formatter)"
        command -v cfn-lint >/dev/null && echo "  ✓ cfn-lint (CloudFormation linter)"
        command -v cfn-lsp-extra >/dev/null && echo "  ✓ cfn-lsp-extra (CloudFormation LSP)"
        command -v stylua >/dev/null && echo "  ✓ stylua (Lua formatter)"
        command -v tombi >/dev/null && echo "  ✓ tombi (TOML formatter)"
        command -v beautysh >/dev/null && echo "  ✓ beautysh (Shell formatter)"
        command -v mcp-hub >/dev/null && echo "  ✓ mcp-hub (MCP integration)"
        command -v prettierd >/dev/null && echo "  ✓ prettierd (Prettier daemon)"
        command -v eslint_d >/dev/null && echo "  ✓ eslint_d (ESLint daemon)"
    fi
    echo ""
    log_info "Usage: source ~/.zshrc (or restart your shell)"
    echo ""
}

# Run main function
main

#!/usr/bin/env bash
#
# Dotfiles Setup Script
# Enhanced with safety, profiles, and distribution support
#

set -euo pipefail

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
PROFILE="${1:-full}"  # full or minimal

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

# Core configuration (shell, git, nvim)
install_core_configs() {
    log_info "Installing core configurations..."
    
    # nvim
    safe_link "$DOTFILES_DIR/.config/nvim/" "$HOME/.config/nvim"
    
    # tmux
    safe_link "$DOTFILES_DIR/.config/tmux/" "$HOME/.config/tmux"
    
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

# Desktop-specific configurations
install_desktop_configs() {
    log_info "Installing desktop configurations..."
    
    # polybar
    safe_link "$DOTFILES_DIR/.config/polybar/" "$HOME/.config/polybar"
    
    # bat
    safe_link "$DOTFILES_DIR/.config/bat/" "$HOME/.config/bat"
    
    # curl
    safe_link "$DOTFILES_DIR/.config/curl/" "$HOME/.config/curl"
    
    # ranger
    safe_link "$DOTFILES_DIR/.config/ranger/" "$HOME/.config/ranger"
    
    # htop
    safe_link "$DOTFILES_DIR/.config/htop/" "$HOME/.config/htop"
    
    # alacritty
    safe_link "$DOTFILES_DIR/.config/alacritty/" "$HOME/.config/alacritty"
    
    # rofi
    safe_link "$DOTFILES_DIR/.config/rofi/" "$HOME/.config/rofi"
    
    # awesome
    safe_link "$DOTFILES_DIR/.config/awesome/" "$HOME/.config/awesome"
    
    # picom
    safe_link "$DOTFILES_DIR/.config/picom/" "$HOME/.config/picom"
    
    # gtk
    safe_link "$DOTFILES_DIR/.config/gtk-3.0/" "$HOME/.config/gtk-3.0"
    
    # stockfish client
    safe_link "$DOTFILES_DIR/.config/stockfish_socket_client/" "$HOME/.config/stockfish_socket_client"
    
    # opencode
    safe_link "$DOTFILES_DIR/.config/opencode/" "$HOME/.config/opencode"
    
    # vim
    backup_existing "$HOME/.vim"
    safe_link "$DOTFILES_DIR/.vim" "$HOME/.vim"
    
    # xinitrc and screenrc
    safe_link "$DOTFILES_DIR/.xinitrc" "$HOME/.xinitrc"
    safe_link "$DOTFILES_DIR/.screenrc" "$HOME/.screenrc"

    # pi
    safe_link "$DOTFILES_DIR/.pi" "$HOME/.pi"
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
    
    # Install configurations based on profile
    case "$PROFILE" in
        minimal)
            log_info "Installing MINIMAL profile (shell + git + nvim only)"
            install_core_configs
            ;;
        full|*)
            log_info "Installing FULL profile (all configurations)"
            install_core_configs
            install_desktop_configs
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
    echo ""
    log_info "Usage: source ~/.zshrc (or restart your shell)"
    echo ""
}

# Run main function
main

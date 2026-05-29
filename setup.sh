#!/usr/bin/env bash
# =============================================================================
# dotfiles setup script
# =============================================================================
# Sets up vim, nvim (LazyVim), tmux, and git on a fresh machine.
# Strategy: symlink each config file from this repo to its expected location
# so that editing the dotfiles repo immediately reflects in the live config.
#
# Usage:  bash setup.sh
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colours
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step()  { echo -e "\n${CYAN}──── $1 ────${NC}"; }

# -----------------------------------------------------------------------------
# Prerequisites
# -----------------------------------------------------------------------------
check_prereqs() {
    step "Checking prerequisites"
    local missing=()
    for cmd in git nvim tmux vim; do
        if command -v "$cmd" &>/dev/null; then
            info "$cmd  $(command -v "$cmd")"
        else
            warn "$cmd not found"
            missing+=("$cmd")
        fi
    done
    if [ ${#missing[@]} -ne 0 ]; then
        error "Please install the missing tools before continuing: ${missing[*]}"
    fi
}

# -----------------------------------------------------------------------------
# Helper: back up an existing file/symlink then create a new symlink
# -----------------------------------------------------------------------------
link() {
    local src="$1"   # absolute path inside this repo
    local dst="$2"   # target location (e.g. ~/.vimrc)

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        warn "Backing up existing $dst → $BACKUP_DIR/"
        mv "$dst" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    info "Linked  $dst"
    info "      → $src"
}

# -----------------------------------------------------------------------------
# git
# -----------------------------------------------------------------------------
setup_git() {
    step "Git"

    # Read current values as defaults so repeated runs stay idempotent.
    local current_name
    current_name="$(git config --global user.name 2>/dev/null || echo "")"
    local current_email
    current_email="$(git config --global user.email 2>/dev/null || echo "")"

    local prompt_name="${current_name:-Your Name}"
    local prompt_email="${current_email:-you@example.com}"

    read -rp "  Git user name  [${prompt_name}]: "  git_name
    read -rp "  Git user email [${prompt_email}]: " git_email

    git_name="${git_name:-$prompt_name}"
    git_email="${git_email:-$prompt_email}"

    link "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

    # Write personal info into the linked file after symlinking.
    git config --global user.name  "$git_name"
    git config --global user.email "$git_email"
    info "Set user.name=$git_name  user.email=$git_email"
}

# -----------------------------------------------------------------------------
# vim
# -----------------------------------------------------------------------------
setup_vim() {
    step "Vim"
    mkdir -p "$HOME/.vim/undo"
    link "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
}

# -----------------------------------------------------------------------------
# tmux
# -----------------------------------------------------------------------------
setup_tmux() {
    step "Tmux"
    link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        info "Installing TPM (tmux plugin manager)..."
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        info "TPM installed."
    else
        info "TPM already present, skipping."
    fi
}

# -----------------------------------------------------------------------------
# neovim (LazyVim)
# -----------------------------------------------------------------------------
setup_nvim() {
    step "Neovim (LazyVim)"

    local nvim_config="$HOME/.config/nvim"

    if [ ! -d "$nvim_config" ]; then
        info "Bootstrapping LazyVim starter..."
        git clone --depth=1 https://github.com/LazyVim/starter "$nvim_config"
        rm -rf "$nvim_config/.git"
        info "LazyVim starter cloned."
    else
        info "~/.config/nvim already exists — symlinking our files on top."
    fi

    # Symlink only the files we own; the rest of the LazyVim scaffold stays as-is.
    link "$DOTFILES_DIR/nvim/init.lua"                    "$nvim_config/init.lua"
    link "$DOTFILES_DIR/nvim/lua/config/lazy.lua"         "$nvim_config/lua/config/lazy.lua"
    link "$DOTFILES_DIR/nvim/lua/config/options.lua"      "$nvim_config/lua/config/options.lua"
    link "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua" "$nvim_config/lua/plugins/colorscheme.lua"
    link "$DOTFILES_DIR/nvim/lua/plugins/lualine.lua"     "$nvim_config/lua/plugins/lualine.lua"
}

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
print_next_steps() {
    echo ""
    echo -e "${GREEN}Setup complete!${NC}"
    echo ""
    echo "  Next steps:"
    echo "  1. Tmux plugins  — start tmux, then press <C-a I> to install plugins"
    echo "  2. Nvim plugins  — open nvim; lazy.nvim will auto-install everything"
    echo "  3. LSP servers   — open a .cpp or .py file; Mason installs clangd/"
    echo "                     basedpyright automatically on first use"
    echo ""
    echo "  Backups (if any) are in: $BACKUP_DIR"
    echo ""
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
main() {
    echo ""
    echo "  ╔══════════════════════════╗"
    echo "  ║     dotfiles  setup      ║"
    echo "  ╚══════════════════════════╝"

    check_prereqs
    setup_git
    setup_vim
    setup_tmux
    setup_nvim
    print_next_steps
}

main "$@"

# ============================================================================
#  .zshrc — tampilan shell (minimal)
#  Fokus: theme, prompt, warna, ikon, dan tampilan completion.
#  Tanpa nvm, bun, Android SDK, Maestro, broot, x-cmd, dan API key.
# ============================================================================

# --- PATH ------------------------------------------------------------------
# Oh My Posh biasanya dipasang di ~/.local/bin.
typeset -U path
path=("$HOME/.local/bin" $path)

# --- Oh My Zsh -------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"          # fallback kalau Oh My Posh tidak tersedia

# zsh-autosuggestions: saran perintah berwarna saat mengetik
plugins=(zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# --- Prompt: Oh My Posh ----------------------------------------------------
# Theme diutamakan dari cache lokal; fallback ke URL kalau belum ada.
OMP_THEME="$HOME/.config/oh-my-posh/emodipt-extend.omp.json"
if command -v oh-my-posh >/dev/null 2>&1; then
  if [ -f "$OMP_THEME" ]; then
    eval "$(oh-my-posh init zsh --config "$OMP_THEME")"
  else
    eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/emodipt-extend.omp.json)"
  fi
fi

# --- Alias tampilan: eza (warna + ikon) ------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias l='eza -l --icons'
  alias la='eza -a --icons'
  alias ll='eza -la --icons'
  alias lt='eza --tree --icons'
fi

# --- Terminal --------------------------------------------------------------
# Matikan mouse tracking agar terminal tidak menampilkan escape sequence.
printf "\e[?1000l\e[?1002l\e[?1003l\e[?1006l"

# --- Tampilan completion ---------------------------------------------------
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:cd:*' file-patterns '%p(^-/):directories'

# --- fzf-tab: menu completion dengan preview eza ---------------------------
if [ -f "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh" ]; then
  source "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"
  if command -v eza >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
  fi
fi

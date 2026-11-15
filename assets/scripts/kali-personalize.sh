#!/usr/bin/env bash
#
# kali-personalize.sh  —  Make a fresh Kali feel like *yours*, in one command.
#
# Red Sands Exploitation Arena · sample script · The Pharaoh's Forge
#
# WHAT IT DOES  (all local — no internet, no root needed):
#   * backs up your current shell config first
#   * adds a tidy set of aliases + helper functions
#   * gives you a clearer prompt that shows the git branch and last exit status
#   * creates ~/bin on your PATH and an ~/engagements workspace skeleton
#
# It is IDEMPOTENT: run it as many times as you like. Everything it adds lives
# in one managed file (~/.config/red-sands/personal.sh) that it rewrites each
# run, plus a single 'source' line added to ~/.bashrc exactly once.
#
# >>> READ THIS SCRIPT BEFORE YOU RUN IT. That habit is the whole point. <<<
#
# Usage:  bash kali-personalize.sh
# Undo :  remove the red-sands block from ~/.bashrc and delete
#         ~/.config/red-sands/   (backups live in ~/.config/red-sands/backups/)

set -euo pipefail

RS_DIR="$HOME/.config/red-sands"
RS_FILE="$RS_DIR/personal.sh"
BACKUP_DIR="$RS_DIR/backups/$(date +%Y%m%d-%H%M%S)"
MARK_OPEN="# >>> red-sands personalize >>>"
MARK_CLOSE="# <<< red-sands personalize <<<"

say() { printf '\033[38;5;179m[*]\033[0m %s\n' "$1"; }

# 0. Personal config belongs to your user, never root.
if [ "$(id -u)" -eq 0 ]; then
  echo "Run this as your normal user, not root. Aborting." >&2
  exit 1
fi

# 1. Back up anything we might touch.
mkdir -p "$BACKUP_DIR"
for f in .bashrc .bash_aliases .profile; do
  [ -f "$HOME/$f" ] && cp -a "$HOME/$f" "$BACKUP_DIR/"
done
say "Backed up shell config to $BACKUP_DIR"

# 2. A place for your own scripts, and a reusable engagement skeleton.
mkdir -p "$HOME/bin"
mkdir -p "$HOME/engagements/_template"/{scans,loot,notes,screenshots}
say "Created ~/bin and ~/engagements/_template skeleton"

# 3. Write the managed config file (rewritten every run — edit it to taste).
mkdir -p "$RS_DIR"
cat > "$RS_FILE" <<'RSEOF'
# Managed by kali-personalize.sh — edit freely, but note a re-run overwrites this file.

# --- PATH: your own scripts come first ---
case ":$PATH:" in *":$HOME/bin:"*) ;; *) export PATH="$HOME/bin:$PATH" ;; esac

# --- Aliases: small, safe quality-of-life ---
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias myip='ip -brief -color address'     # your interfaces at a glance
alias ports='ss -tulpn'                    # what is listening on THIS box
alias serve='python3 -m http.server 8000' # quick file share (never point it at a client net without permission)

# --- Functions: the things aliases cannot do ---

# mkt <name> : spin up an engagement folder from the template and cd into it
mkt() {
  local name="${1:?usage: mkt <engagement-name>}"
  cp -r "$HOME/engagements/_template" "$HOME/engagements/$name"
  cd "$HOME/engagements/$name" && echo "now in $PWD"
}

# target <ip> : remember a target for this shell; then use $T anywhere
target() { export T="${1:?usage: target <ip>}"; echo "T=$T"; }

# extractports <nmap.gnmap> : pull open ports into a comma list (great for nmap -p)
extractports() {
  local f="${1:?usage: extractports <nmap -oG file>}"
  grep -oE '[0-9]+/open' "$f" | cut -d/ -f1 | sort -un | paste -sd,
}

# mkcd <dir> : make a directory and step into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# --- Prompt: user@host, path, git branch, and a marker that turns red on failure ---
__rs_git() { git branch --show-current 2>/dev/null | sed 's/.*/ (&)/'; }
__rs_prompt() {
  local ec=$?                              # capture the last exit code FIRST
  local mark
  if [ "$ec" -eq 0 ]; then mark='\[\e[38;5;108m\]'; else mark='\[\e[38;5;167m\]'; fi
  PS1="\[\e[38;5;108m\]\u@\h\[\e[0m\] \[\e[38;5;179m\]\w\[\e[38;5;110m\]\$(__rs_git)\[\e[0m\] ${mark}\342\235\257\[\e[0m\] "
}
PROMPT_COMMAND=__rs_prompt
RSEOF
say "Wrote $RS_FILE"

# 4. Hook it into ~/.bashrc exactly once.
if ! grep -qF "$MARK_OPEN" "$HOME/.bashrc" 2>/dev/null; then
  {
    echo ""
    echo "$MARK_OPEN"
    echo "[ -f \"$RS_FILE\" ] && source \"$RS_FILE\""
    echo "$MARK_CLOSE"
  } >> "$HOME/.bashrc"
  say "Hooked it into ~/.bashrc"
else
  say "~/.bashrc already hooked — nothing to add"
fi

say "Done. Open a new terminal, or run:  source ~/.bashrc"

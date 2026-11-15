#!/usr/bin/env bash
#
# kali-tools.sh  —  Install *your* preferred extras on top of a stock Kali.
#
# Red Sands Exploitation Arena · sample script · The Pharaoh's Forge
#
# !!  NEEDS INTERNET and sudo. Run this AT HOME, not on the Dojo network
#     (the Dojo is offline on purpose). This is a starting point, not a rule —
#     open it up and edit the TOOLS list to match how *you* actually work.
#
# It is idempotent: apt simply re-confirms anything already installed. Tools
# install one at a time so a single unknown name does not stop the rest.
#
# >>> READ THIS SCRIPT BEFORE YOU RUN IT. <<<
#
# Usage:  bash kali-tools.sh

set -uo pipefail

# --- Edit this list. These are quality-of-life CLI upgrades, not an arsenal. ---
TOOLS=(
  bat        # a 'cat' with syntax highlighting + line numbers (runs as 'batcat' on Kali)
  lsd        # a modern 'ls' with icons and colour
  fzf        # fuzzy finder; gives you a Ctrl-R history search that actually works
  ripgrep    # 'rg' — very fast recursive grep
  jq         # slice and shape JSON on the command line
  tmux       # terminal multiplexer — keep sessions alive across drops
  tree       # quick directory trees
  ncdu       # find what ate your disk
  git        # version your dotfiles, notes, and scripts
)

# Make sure we can elevate before we start.
if [ "$(id -u)" -ne 0 ] && ! sudo -v; then
  echo "This needs sudo to install packages. Aborting." >&2
  exit 1
fi
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "[*] Updating package lists..."
$SUDO apt-get update -y

ok=(); fail=()
for pkg in "${TOOLS[@]}"; do
  echo "[*] Installing $pkg..."
  if $SUDO apt-get install -y "$pkg"; then ok+=("$pkg"); else fail+=("$pkg"); fi
done

echo
echo "[+] Installed / confirmed: ${ok[*]:-none}"
if [ "${#fail[@]}" -gt 0 ]; then
  echo "[!] Skipped (the package name may differ on your release): ${fail[*]}"
  echo "    Tip: 'apt-cache search <term>' finds the current name."
fi
echo "[*] Note: 'bat' is launched as 'batcat' on Kali — add  alias bat='batcat'  if you like."

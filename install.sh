#!/usr/bin/env bash
# termshot installer: gunshot + screen flash every time you hit Enter in a terminal
set -e

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG_DIR="$HOME/.config/termshot"
MARK_BEGIN="# >>> termshot >>>"
MARK_END="# <<< termshot <<<"

mkdir -p "$CFG_DIR"
cp -f "$SRC_DIR/shot.wav" "$CFG_DIR/shot.wav"
echo "Sound installed to $CFG_DIR/shot.wav"

# check for a player
if ! command -v paplay >/dev/null 2>&1 && ! command -v aplay >/dev/null 2>&1 && ! command -v ffplay >/dev/null 2>&1; then
    echo
    echo "WARNING: no audio player found (paplay / aplay / ffplay)."
    echo "  Debian/Ubuntu: sudo apt install pulseaudio-utils   # or alsa-utils"
    echo "  Arch:          sudo pacman -S libpulse              # or alsa-utils"
    echo "  Fedora:        sudo dnf install pulseaudio-utils    # or alsa-utils"
    echo
fi

install_snippet() {
    local rcfile="$1" snippetfile="$2"
    [ -f "$rcfile" ] || touch "$rcfile"
    if grep -qF "$MARK_BEGIN" "$rcfile" 2>/dev/null; then
        echo "Already installed in $rcfile (skipping, run uninstall.sh first to reinstall)."
        return
    fi
    {
        echo ""
        echo "$MARK_BEGIN"
        cat "$snippetfile"
        echo "$MARK_END"
    } >> "$rcfile"
    echo "Installed into $rcfile"
}

case "$(basename "$SHELL")" in
    zsh)
        install_snippet "$HOME/.zshrc" "$SRC_DIR/termshot-zsh.sh"
        ;;
    *)
        install_snippet "$HOME/.bashrc" "$SRC_DIR/termshot-bash.sh"
        ;;
esac

echo
echo "Done. Open a new terminal (or 'source ~/.bashrc' / 'source ~/.zshrc') and hit Enter."
echo "Tune it with: export TERMSHOT_FLASH_MS=100   (before sourcing, or add to rc file)"

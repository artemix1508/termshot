#!/usr/bin/env bash
set -e
MARK_BEGIN="# >>> termshot >>>"
MARK_END="# <<< termshot <<<"

strip() {
    local rcfile="$1"
    [ -f "$rcfile" ] || return
    if grep -qF "$MARK_BEGIN" "$rcfile"; then
        sed -i "/$MARK_BEGIN/,/$MARK_END/d" "$rcfile"
        echo "Removed termshot block from $rcfile"
    fi
}

strip "$HOME/.bashrc"
strip "$HOME/.zshrc"
echo "You can also delete ~/.config/termshot if you don't want the sound file around."

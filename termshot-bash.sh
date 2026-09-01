# ~~~ termshot: gunshot + screen flash on Enter (bash) ~~~
TERMSHOT_SOUND="${TERMSHOT_SOUND:-$HOME/.config/termshot/shot.wav}"
TERMSHOT_FLASH_MS="${TERMSHOT_FLASH_MS:-60}"

_termshot_effect() {
    printf '\e[?5h'                      # reverse video ON (flash)
    ( paplay "$TERMSHOT_SOUND" 2>/dev/null \
        || aplay -q "$TERMSHOT_SOUND" 2>/dev/null \
        || ffplay -nodisp -autoexit -loglevel quiet "$TERMSHOT_SOUND" 2>/dev/null ) &
    sleep "$(awk "BEGIN{print $TERMSHOT_FLASH_MS/1000}")"
    printf '\e[?5l'                      # reverse video OFF
}

# Ctrl-X 1 is an unused chord we hijack to run the function synchronously,
# then \C-j (linefeed) triggers the real accept-line — Enter itself never
# gets rebound to something that blocks command submission.
bind -x '"\C-x1": _termshot_effect'
bind '"\r": "\C-x1\C-j"'

# ~~~ termshot: gunshot + screen flash on Enter (zsh) ~~~
TERMSHOT_SOUND="${TERMSHOT_SOUND:-$HOME/.config/termshot/shot.wav}"
TERMSHOT_FLASH_MS="${TERMSHOT_FLASH_MS:-60}"

termshot-accept-line() {
    print -n '\e[?5h'                    # reverse video ON (flash)
    ( paplay "$TERMSHOT_SOUND" 2>/dev/null \
        || aplay -q "$TERMSHOT_SOUND" 2>/dev/null \
        || ffplay -nodisp -autoexit -loglevel quiet "$TERMSHOT_SOUND" 2>/dev/null ) &!
    sleep "$(awk "BEGIN{print $TERMSHOT_FLASH_MS/1000}")"
    print -n '\e[?5l'                    # reverse video OFF
    zle accept-line
}
zle -N termshot-accept-line
bindkey '^M' termshot-accept-line

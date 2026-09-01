# termshot

Gunshot sound + screen flash every time you hit **Enter** in your terminal.

No global keylogger, no X11/Wayland input hooks — it's a shell-level trick, so it works the same in any terminal emulator, on any display server.

## How it works

Enter is rebound so that pressing it does three things instead of one:

1. Flashes the terminal using the built-in **reverse-video escape sequence** (`\e[?5h` / `\e[?5l`) — the same trick terminals use for a "visual bell." This inverts the terminal's colors for a moment, giving you a screen flash with zero external dependencies.
2. Plays a `.wav` in the background via whichever of `paplay` / `aplay` / `ffplay` is available on your system.
3. Still submits the command line as normal, so nothing about how you use the shell changes.

The two shells do this slightly differently under the hood:

- **bash** has no clean way to run something on Enter and still submit the line, so it uses a small `bind -x` trick: Enter is remapped to a macro that triggers an unused key chord (which runs the effect function synchronously), then sends a linefeed (`\C-j`), which bash's default keymap also treats as "submit the line."
- **zsh** has real programmable line-editor widgets (ZLE), so it's cleaner: a custom widget runs the effect, then calls `zle accept-line` itself.

Because everything happens inside your shell's line editor, there's no dependency on your window manager, compositor, or display server — it works identically on X11 and Wayland.

## Install

```bash
git clone https://github.com/artemix1508/termshot termshot
cd termshot
chmod +x install.sh
./install.sh
```

The installer:
- copies `shot.wav` to `~/.config/termshot/shot.wav`
- detects your shell from `$SHELL` and appends a small marked block to `~/.bashrc` or `~/.zshrc`
- warns you if it can't find an audio player

Open a new terminal (or `source ~/.bashrc` / `source ~/.zshrc`) and hit Enter.

If you use both bash and zsh, just run `./install.sh` once from each shell.

## Uninstall

```bash
./uninstall.sh
```

Removes the marked block from your rc file(s). Delete `~/.config/termshot` too if you want the sound file gone as well.

## Configuration

Set these before the snippet loads — either export them above the `>>> termshot >>>` block in your rc file, or edit the block directly:

| Variable             | Default                          | Meaning                              |
|----------------------|-----------------------------------|---------------------------------------|
| `TERMSHOT_SOUND`     | `~/.config/termshot/shot.wav`    | Path to the sound file to play        |
| `TERMSHOT_FLASH_MS`  | `60`                              | How long the reverse-video flash lasts (ms) |

To use your own sound, either overwrite the default file:

```bash
cp your-sound.wav ~/.config/termshot/shot.wav
```

or point at it directly:

```bash
export TERMSHOT_SOUND="$HOME/sounds/gunshot.wav"
```

## Requirements

- `bash` or `zsh`
- One of: `paplay` (pulseaudio-utils / pipewire-pulse), `aplay` (alsa-utils), or `ffplay` (ffmpeg)
- A terminal emulator that supports reverse-video mode (`DECSCNM`) — true of essentially all of them: gnome-terminal, kitty, alacritty, konsole, foot, xterm, etc. If yours doesn't, the sound still plays; you just won't get the flash.

## Files

```
.
├── install.sh          # installer
├── uninstall.sh         # removes the rc-file block
├── termshot-bash.sh     # the bash hook (bind -x trick)
├── termshot-zsh.sh      # the zsh hook (ZLE widget)
└── shot.wav             # default sound effect
```

## Notes

- Rapid Enter presses (e.g. holding it down) will overlap sounds, since playback always runs in the background rather than blocking your typing.
- The bundled `shot.wav` is synthesized, not a sampled recording — swap it for a royalty-free sound (e.g. from freesound.org, filtered to CC0) if you want something punchier.

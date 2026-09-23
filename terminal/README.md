# Terminal themes

Six generated files cover Alacritty, foot and kitty in light and dark modes. Clone once, then import a file from the checkout; leave your fonts, padding, opacity and keybindings in your own terminal config.

```sh
git clone https://github.com/T-450/zirconium.git ~/.local/share/zirconium
```

Pick **one** variant per terminal. To update later, run `git -C ~/.local/share/zirconium pull --ff-only`. Appearance changes are terminal-specific: change the imported filename, then restart or reload the terminal according to its own configuration. The site's appearance toggle only previews the colors; it does not switch terminal settings.

### Alacritty (TOML)

In `~/.config/alacritty/alacritty.toml`, set the top-level `[general]` table to import the dark file:

```toml
[general]
import = ["~/.local/share/zirconium/terminal/alacritty/zirconium-dark.toml"]
```

For light mode, use `import = ["~/.local/share/zirconium/terminal/alacritty/zirconium-light.toml"]` instead. If you already have `[general]`, add only its `import` key; do not create a duplicate table. Keep any other existing imports you use.

### foot (INI)

In the default (top-level) section of `~/.config/foot/foot.ini`, **before** any `[section]`, include the dark file:

```ini
include=~/.local/share/zirconium/terminal/foot/zirconium-dark.ini
```

For light mode, use `include=~/.local/share/zirconium/terminal/foot/zirconium-light.ini` instead. Each file sets `initial-color-theme` and its matching `[colors-dark]` or `[colors-light]` section; remove any conflicting `initial-color-theme` in your own config. Validate either checkout file with `foot -c ~/.local/share/zirconium/terminal/foot/zirconium-dark.ini -C` (substitute `light` for the other variant). Foot also accepts the clone-relative `include` from a user config; this was checked locally.

### kitty (conf)

In `~/.config/kitty/kitty.conf`, include the dark file:

```conf
include ${HOME}/.local/share/zirconium/terminal/kitty/zirconium-dark.conf
```

For light mode, use `include ${HOME}/.local/share/zirconium/terminal/kitty/zirconium-light.conf` instead. kitty expands environment variables in include paths. Do not include both variants simultaneously.

## Scope

ANSI 0–15, foreground, background, cursor and selection are provided. These are truecolor definitions: the supplied Zig Docs xterm-256 mapping did **not** define ANSI 0–15. `palette/zirconium.json` is authoritative; generated files are not meant to be hand-edited. Check them with `node scripts/generate.mjs --check`. Your terminal's own 16–255 extended palette remains unchanged. Alacritty and kitty CLIs were unavailable for local runtime validation; verify imports in those terminals after installing them.

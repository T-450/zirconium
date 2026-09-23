# Terminal themes

Clone the repository; import **one** variant from the checkout:

```sh
git clone https://github.com/T-450/zirconium.git ~/.local/share/zirconium
```

**Alacritty** — in `~/.config/alacritty/alacritty.toml` (reuse an existing `[general]` table):

```toml
[general]
import = ["~/.local/share/zirconium/terminal/alacritty/zirconium-dark.toml"]
```

**foot** — at the top of `~/.config/foot/foot.ini`, before any section; remove a conflicting `initial-color-theme`:

```ini
include=~/.local/share/zirconium/terminal/foot/zirconium-dark.ini
```

**kitty** — in `~/.config/kitty/kitty.conf`:

```conf
include ${HOME}/.local/share/zirconium/terminal/kitty/zirconium-dark.conf
```

Replace `dark` with `light` in any import for the light palette. Restart or reload your terminal after changing variants. Update the clone with `git -C ~/.local/share/zirconium pull --ff-only`. ANSI 0–15, cursor and selection are included; terminal colors 16–255 are unchanged.

# Zirconium palette notes

Zirconium is **inspired by**, not affiliated with, Zig's documentation palette. The provided `zig-docs-xterm256.json` and preview are nearest-neighbor xterm-256 approximations of a Zig language-reference template, not a verified snapshot of the live stylesheet. Source indices 16–255 do **not** specify terminal ANSI 0–15. Our ANSI ramps, selection, cursor, diagnostics, UI surfaces and `ui.controlBorder` are original additions. The product is designed primarily for truecolor displays; `cterm` approximations use nearest xterm 16–255 for Neovim's 256-color fallback.

| Role | Supplied light | Zirconium light | Supplied dark | Zirconium dark |
| --- | --- | --- | --- | --- |
| Editor background | `#ffffff` (preview default) | `#f9f8f4` | `#121212` page / `#262626` code | `#161616` / `#242424` panel |
| Main text | `#000000` (inherited preview) | `#303030` | `#d0d0d0` | `#d9d9d3` |
| Keywords | `#303030` | `#333333` | `#eeeeee` | `#eeeeee` |
| Strings | `#d7005f` | `#a8004e` | `#00ff5f` | `#7ce89a` |
| Builtins | `#005f87` | `#005f7d` | `#ff875f` | `#ff9b79` |
| Comments | `#585858` | `#595958` | `#afaf87` | `#b0ae8a` |
| Functions | `#870000` | `#890b12` | `#afafff` | `#bebaff` |
| Literal / number | `#005f5f` | `#00635e` | `#ff8787` | `#ff9996` |
| Types | `#5f5f87` | `#555887` | `#5f87ff` | `#8ca8ff` |

The two themes share *roles*, not equal color coordinates. Dark reads like forged graphite with signals; light like warm technical paper with engraved ink. Bold keywords, functions and types and optional italic comments retain the reference's hierarchy. Ancillary UI avoids overwhelming source text; diagnostic colors are separated by role and tested for legibility.

`palette/zirconium.json` is the source of truth. Run `node scripts/generate.mjs` after editing it; commit the updated Lua, terminal and site exports. Run `node scripts/generate.mjs --check` and `node scripts/check-palette.mjs` to verify drift and contrast. The check measures WCAG reading contrast on editor and code panel backgrounds, selection and cursor; the minimum currently is **4.96:1 dark** and **5.24:1 light**. It separately requires at least **3:1** for `ui.controlBorder` against page, panel and muted control surfaces. Softer decorative borders and ANSI bright white/black are not reading-text pairs; terminal applications choose how to apply ANSI foregrounds/backgrounds.

# Palette source

`zirconium.json` defines both variants and ANSI 0–15. Zirconium adapts an **unverified, approximate** xterm-256 preview of Zig documentation colors; it is not affiliated with Zig. That reference covers indices 16–255, not ANSI 0–15. UI surfaces, ANSI colors and controls are original additions.

After editing JSON, run `node scripts/generate.mjs` and commit the Lua, terminal and site exports. `node scripts/generate.mjs --check` detects drift; `node scripts/check-palette.mjs` enforces at least 4.5:1 reading contrast and 3:1 control-border contrast on tested surfaces. Neovim's 256-color fallback is approximate; truecolor is preferred.

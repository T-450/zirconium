# Developing Zirconium

## Tooling

- Neovim 0.8+ for theme smoke tests; a truecolor-capable terminal for visual inspection.
- Node.js (current LTS or newer) and npm for palette exports/checks and the static Svelte/Vite site.
- Optional Nix + direnv: `.envrc` uses `flake.nix` to make `stylua`, `lua-language-server` and Node available. If Nix/direnv is unavailable, install these tools separately; no Nix dependency is required to use the theme.
- The available `foot` CLI can validate its own generated config with `foot -c terminal/foot/zirconium-dark.ini -C` (also try light). Test other terminal formats with their CLIs when installed.

The repository `.envrc` sets `XDG_CONFIG_HOME` to the parent of the checkout and `NVIM_APPNAME=zirconium`, so `nvim` launched inside the project finds `init.lua` as its development config. The demo's `init.lua` loads optional plugins and **may clone lazy.nvim** on first run; do not use it in automated/offline smoke checks. Never run this demo against a production Neovim profile unintentionally.

## Working on colors

1. Edit semantic tokens in `palette/zirconium.json` (both appearances, UI control boundaries and 16 ANSI entries). The separately supplied reference is read-only input, not a build-time dependency.
2. Run `node scripts/generate.mjs` from the repository root. This updates `lua/zirconium/palette.lua`, six `terminal/` config files and `site/src/lib/palette.json`.
3. Run `node scripts/generate.mjs --check` and `node scripts/check-palette.mjs`. Check the reference mapping in `palette/README.md` and curated SVG assets for necessary updates.
4. Exercise both backgrounds and inspect real code (including Zig) in Neovim and a terminal. Check diagnostics, diff, selection, popup and status line as well as source syntax.

## Safe Neovim smoke tests

Run from the repository root. `-u NONE` avoids plugin installs and your personal config:

```sh
nvim --headless -u NONE --cmd 'set rtp+=.' \
  -c 'set termguicolors' -c 'colorscheme zirconium-dark' \
  -c "lua assert(vim.g.colors_name == 'zirconium-dark')" \
  -c 'colorscheme zirconium-light' \
  -c "lua assert(vim.g.terminal_color_15 == '#ffffff')" \
  -c 'qa!'
```

Run `nvim --headless -u NONE --cmd 'set rtp+=.' -l tests/nvim-smoke.lua` for both variants, ANSI slots, non-truecolor fallback, transparency and explicit cterm override regression checks. You can also repeat the manual example with `set notermguicolors` and inspect `ctermfg`/`ctermbg` in `vim.api.nvim_get_hl(0, { name = 'Normal' })`. Call `require('zirconium').setup({ transparent = true, overrides = ... })` before applying. `:colorscheme zirconium` follows `vim.o.background`; explicit light/dark entrypoints force a variant.

## Site

```sh
npm ci --prefix site
npm run dev --prefix site   # local preview
npm run build --prefix site # output: site/dist/
npm run test:prefix --prefix site # check JS, CSS, fonts and SVGs under /zirconium/
```

The build first checks generated palette exports. `node scripts/check-palette.mjs` checks reading pairs at 4.5:1 and site control boundaries at 3:1 on their actual surfaces. The site uses a relative Vite base so its assets also load under GitHub Pages' `/zirconium/` project path. Its Open Graph image URL is absolute for the approved Pages deployment; change that URL if publishing to a different host. It has no runtime font CDN; font licenses are bundled under `site/public/fonts/`. Use a browser at mobile and desktop widths to check appearance toggles, swatch/snippet clipboard interactions including denial, focus visibility, reduced motion and horizontal overflow. `site/node_modules/` and `site/dist/` are ignored.

### GitHub Pages deployment

`.github/workflows/pages.yml` builds `site/dist/` on pushes to `main` or manual `workflow_dispatch`, runs the palette/build/prefix checks, and uploads/deploys the static artifact using GitHub Actions. The repository owner must first enable GitHub Pages with **Source: GitHub Actions** in repository settings; this does not publish from the repository root or require committing `site/dist/`. The intended project URL is `https://t-450.github.io/zirconium/`. Confirm the workflow and live page after publication; a local build alone is not evidence of deployment.

## Repository conventions

Use `.stylua.toml` for Lua formatting (run `stylua --check lua colors` when available); keep generated files untouched manually and document any new semantic role. Neovim integrations should not pull their plugins in as required dependencies. The configs are intended as drop-ins, not replacements for users' fonts, padding or keyboard shortcuts.

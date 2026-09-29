# Zirconium for Pi

Dark charcoal and light ivory themes, generated from `palette/zirconium.json`.
Amber marks focus; mint, rose and ochre distinguish success, error and warning.
Secondary text stays readable rather than disappearing into the terminal.

## Themes

From the repository root:

```sh
mkdir -p ~/.pi/agent/themes
cp pi/themes/zirconium-*.json ~/.pi/agent/themes/
```

Run `/reload`, then select `zirconium-dark` or `zirconium-light` in `/settings`.
Pi 0.87 also accepts `"theme": "zirconium-light/zirconium-dark"` in
`~/.pi/agent/settings.json` to follow terminal appearance.

For a one-off preview:

```sh
pi --theme ./pi/themes --use-theme zirconium-dark
```

Pi's theme format does not set the terminal's base background, font or opacity.
Use the matching [terminal palette](../terminal/README.md) for the intended
canvas (`#161616` dark, `#f9f8f4` light). No desktop settings are changed here.
Truecolor is recommended; Pi approximates colors on 256-color terminals.

## LazyPi component redesign

The optional `pi/extensions/zirconium-ui.ts` extension adds:

- A labeled Prompt/Shell frame with Ready/Working state, preserving native input,
  scrolling, completion, paste, history and keyboard controls.
- A two-row status area: branch/provider/model, then tokens/cache/cost/context/usage.
  Long rows wrap rather than discarding statistics on narrow terminals.
- Amber usage meters with neutral tracks, warning/error thresholds and exact percentages.
- A quieter working indicator and preservation of other extensions' footer statuses.

Directory and todo widgets retain their upstream layouts and commands, restyled by
Zirconium's semantic colors. This extension does not fork or patch those packages.

LazyPi's powerbar producers still supply the real data. Disable **only** its original
renderer and load this extension in `~/.pi/agent/settings.json` (merge these entries,
do not replace your other packages or extensions):

```json
{
  "packages": [
    {
      "source": "npm:@juanibiapina/pi-powerbar",
      "extensions": ["!src/powerbar/index.ts"]
    }
  ],
  "extensions": ["/absolute/path/to/zirconium/pi/extensions/zirconium-ui.ts"],
  "theme": "zirconium-dark"
}
```

Run `/reload` or restart Pi. Keep the repository at that path. The status layout
shows all producer segments, including third-party additions; original powerbar
layout settings do not apply to this replacement. The renderer needs the powerbar
producers for statistics and does not fabricate values when they are unavailable.

For package distribution, the root `package.json` exposes both themes and the
extension. `pi install /absolute/path/to/zirconium` can load them together; in that
case remove copied user themes and the explicit extension entry first to avoid
resource collisions. Do not install both ways. Git installation is available once
these changes are committed and pushed.

To revert locally, remove the Zirconium extension entry, restore the powerbar entry
to `"npm:@juanibiapina/pi-powerbar"`, select your previous theme, and `/reload`.

## Design and checks

All 56 Pi color roles are explicit, including fullscreen search, scrollbar and
maximum-thinking states. Tool panels use low-intensity semantic tints; diffs and
syntax retain the original palette. HTML export uses the same surface hierarchy.

The LazyPi directory and todo widgets inherit `text`, `muted`, `dim`, `accent`,
`warning` and `success`. Existing tools and commands remain owned by their packages.
Restart or `/reload` after switching themes if an upstream widget caches colors.

Do not edit generated files in `pi/themes/`. Run:

```sh
node scripts/generate.mjs
node scripts/generate.mjs --check
node --test tests/pi-theme.mjs
npm ci
npm test
npm run check
```

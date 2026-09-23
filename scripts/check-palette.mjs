#!/usr/bin/env node
// Check reading colors against both editor and raised code surfaces.
import { readFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const { dark, light } = JSON.parse(readFileSync(resolve(root, 'palette/zirconium.json'), 'utf8'));
const channel = c => { const n = c / 255; return n <= 0.04045 ? n / 12.92 : ((n + 0.055) / 1.055) ** 2.4; };
function luminance(hex) {
  const [r, g, b] = [1, 3, 5].map(i => channel(parseInt(hex.slice(i, i + 2), 16)));
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}
function ratio(a, b) {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}
let failures = 0;
for (const [name, theme] of Object.entries({ dark, light })) {
  let minimum = { contrast: Infinity, role: '' };
  for (const bg of [theme.surface.bg, theme.surface.panel]) {
    for (const [role, color] of Object.entries({ ...theme.text, ...theme.syntax, ...theme.diagnostic })) {
      if (role === 'inverse') continue; // intentionally used only on the cursor/accent, not the editor surface
      const contrast = ratio(color, bg);
      if (contrast < minimum.contrast) minimum = { contrast, role: `${role} on ${bg}` };
      if (contrast < 4.5) { failures++; console.error(`${name} ${role} on ${bg}: ${contrast.toFixed(2)} < 4.5`); }
    }
  }
  for (const [role, fg, bg] of [
    ['selection', theme.ui.selectionFg, theme.surface.selection],
    ['cursor', theme.text.inverse, theme.ui.cursor],
    ['search', theme.ui.selectionFg, theme.ui.search],
  ]) {
    const contrast = ratio(fg, bg);
    if (contrast < minimum.contrast) minimum = { contrast, role };
    if (contrast < 4.5) { failures++; console.error(`${name} ${role}: ${contrast.toFixed(2)} < 4.5`); }
  }
  console.log(`${name}: minimum ${minimum.contrast.toFixed(2)}:1 (${minimum.role}); editor/code text, syntax, diagnostics, selection, search and cursor`);
  for (const [surface, bg] of Object.entries({ page: theme.surface.bg, panel: theme.surface.panel, control: theme.surface.muted })) {
    const contrast = ratio(theme.ui.controlBorder, bg);
    if (contrast < 3) { failures++; console.error(`${name} control border on ${surface}: ${contrast.toFixed(2)} < 3`); }
  }
  console.log(`${name}: control border contrasts >= 3:1 on page, panel and control surfaces`);
}
if (failures) process.exitCode = 1;
else console.log('Reading pairs meet 4.5:1 and control boundaries meet 3:1.');

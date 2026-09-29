import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const json = path => JSON.parse(readFileSync(new URL(path, import.meta.url), 'utf8'));
const palette = json('../palette/zirconium.json');
// Pi 0.87 theme roles, including the five optional fullscreen/thinking roles.
const roles = `accent border borderAccent borderMuted success error warning muted dim text
thinkingText selectedBg scrollbarTrack scrollbarThumb searchMatchBg searchMatchText
userMessageBg userMessageText customMessageBg customMessageText customMessageLabel
toolPendingBg toolSuccessBg toolErrorBg toolTitle toolOutput mdHeading mdLink mdLinkUrl
mdCode mdCodeBlock mdCodeBlockBorder mdQuote mdQuoteBorder mdHr mdListBullet
toolDiffAdded toolDiffRemoved toolDiffContext syntaxComment syntaxKeyword syntaxFunction
syntaxVariable syntaxString syntaxNumber syntaxType syntaxOperator syntaxPunctuation
thinkingOff thinkingMinimal thinkingLow thinkingMedium thinkingHigh thinkingXhigh thinkingMax bashMode`.split(/\s+/).sort();
function luminance(hex) {
  const rgb = [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16) / 255)
    .map(n => n <= 0.04045 ? n / 12.92 : ((n + 0.055) / 1.055) ** 2.4);
  return rgb[0] * 0.2126 + rgb[1] * 0.7152 + rgb[2] * 0.0722;
}
function contrast(a, b) {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}

for (const variant of ['dark', 'light']) {
  test(`${variant}: complete theme preserves Zirconium identity`, () => {
    const theme = json(`../pi/themes/zirconium-${variant}.json`);
    const p = palette[variant];
    assert.equal(theme.name, `zirconium-${variant}`);
    assert.deepEqual(Object.keys(theme.colors).sort(), roles);
    for (const value of [...Object.values(theme.colors), ...Object.values(theme.export)]) {
      assert.match(value, /^#[0-9a-f]{6}$/i);
    }
    assert.equal(theme.colors.accent, p.ui.accent);
    assert.equal(theme.colors.text, p.text.primary);
    assert.equal(theme.colors.syntaxFunction, p.syntax.function);
    assert.equal(theme.colors.syntaxString, p.syntax.string);
    assert.equal(theme.export.pageBg, p.surface.bg);
    assert.notEqual(theme.colors.toolSuccessBg, theme.colors.toolErrorBg);
  });

  test(`${variant}: reading text and extension tokens meet 4.5:1`, () => {
    const { colors: c, export: e } = json(`../pi/themes/zirconium-${variant}.json`);
    const pairs = [];
    const reading = ['text', 'muted', 'dim', 'thinkingText', 'accent', 'success', 'warning', 'error',
      'toolTitle', 'toolOutput', 'toolDiffAdded', 'toolDiffRemoved', 'toolDiffContext',
      ...roles.filter(role => role.startsWith('syntax'))];
    for (const bg of [e.pageBg, c.userMessageBg, c.customMessageBg, c.toolPendingBg, c.toolSuccessBg, c.toolErrorBg]) {
      for (const role of reading) pairs.push([role, c[role], bg]);
    }
    for (const role of ['text', 'muted', 'dim', 'accent']) pairs.push([`selected ${role}`, c[role], c.selectedBg]);
    pairs.push(['search', c.searchMatchText, c.searchMatchBg]);
    for (const [role, fg, bg] of pairs) {
      assert.ok(contrast(fg, bg) >= 4.5, `${role} ${fg} on ${bg}: ${contrast(fg, bg).toFixed(2)}:1`);
    }
    assert.ok(contrast(c.border, e.pageBg) >= 3, 'control borders must remain visible');
  });
}

test('Pi package exposes themes and the presentation extension', () => {
  assert.deepEqual(json('../package.json').pi, {
    themes: ['./pi/themes/*.json'], extensions: ['./pi/extensions/zirconium-ui.ts'],
  });
});

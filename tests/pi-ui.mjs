import assert from 'node:assert/strict';
import { test } from 'node:test';
import { stripVTControlCharacters as stripAnsi } from 'node:util';
import { visibleWidth } from '@earendil-works/pi-tui';
import { renderStatus, renderEditorBorder, updateSegment } from '../pi/components/status.ts';

const theme = { fg: (_role, text) => text, bg: (_role, text) => text, bold: text => text };
const segments = new Map([
  ['tokens', { id: 'tokens', text: '↑194k ↓2.7k R665k CH99.1% $2.74' }],
  ['context-usage', { id: 'context-usage', text: '', bar: 35, suffix: '35%' }],
  ['provider', { id: 'provider', text: 'openai-codex' }],
  ['model', { id: 'model', text: 'gpt-6-astra · high' }],
  ['sub-weekly', { id: 'sub-weekly', text: '168h 6d17h', bar: 30, suffix: '30%' }],
]);

test('status retains every screenshot value with distinct labels', () => {
  const text = renderStatus(segments, theme, 190).join('\n');
  for (const value of ['194k', '2.7k', '665k', '99.1%', '$2.74', '35%', 'openai-codex', 'gpt-6-astra', 'high', '168h 6d17h', '30%']) {
    assert.ok(text.includes(value), value);
  }
  assert.match(text, /Context/);
  assert.match(text, /Weekly/);
});

test('status wraps instead of discarding information at narrow widths', () => {
  for (const width of [10, 20, 40, 80, 120, 190]) {
    const lines = renderStatus(segments, theme, width);
    assert.ok(lines.every(line => visibleWidth(line) <= width), `width ${width}`);
    const text = lines.map(stripAnsi).join('').replace(/\s/g, '');
    for (const value of ['gpt-6-astra', '194k', '$2.74', '99.1%']) assert.ok(text.includes(value), `${width}: ${value}`);
  }
});

test('unknown segments and wide text survive and values clamp safely', () => {
  const data = new Map([['extra', { id: 'extra', text: '日本語 é test', bar: 300, color: 'not-a-theme-role' }]]);
  assert.ok(renderStatus(data, theme, 20).every(line => visibleWidth(line) <= 20));
  assert.deepEqual(renderStatus(data, theme, 0), []);
  assert.deepEqual(renderStatus(new Map(), theme, 80), []);
});

test('segment removals do not leave stale usage', () => {
  const data = new Map();
  updateSegment(data, { id: 'sub-weekly', text: '168h', bar: 10 });
  assert.equal(data.size, 1);
  updateSegment(data, { id: 'sub-weekly', text: undefined });
  assert.equal(data.size, 0);
  updateSegment(data, { id: 'context-usage', text: '', bar: 0 });
  assert.equal(data.size, 1);
  updateSegment(data, null);
  assert.equal(data.size, 1);
});

test('editor frame fits all widths without taking space from input', () => {
  for (const width of [0, 1, 2, 10, 40, 80, 190]) {
    const line = renderEditorBorder(theme, width, 'Prompt', 'Working');
    assert.equal(visibleWidth(line), width);
  }
  assert.match(renderEditorBorder(theme, 80, 'Prompt', 'Working'), /Working/);
});

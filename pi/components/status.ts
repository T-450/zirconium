import type { Theme } from '@earendil-works/pi-coding-agent';
import { truncateToWidth, visibleWidth, wrapTextWithAnsi } from '@earendil-works/pi-tui';

export interface Segment {
  id: string;
  text?: string;
  suffix?: string;
  icon?: string;
  color?: string;
  bar?: number;
}
type Colors = Pick<Theme, 'fg' | 'bg' | 'bold'>;

export function updateSegment(segments: Map<string, Segment>, payload: unknown): void {
  if (!payload || typeof payload !== 'object' || !('id' in payload) || typeof payload.id !== 'string') return;
  const data = payload as Segment;
  if (!data.text && data.bar === undefined) segments.delete(data.id);
  else segments.set(data.id, { ...data });
}

const labels: Record<string, string> = {
  'git-branch': 'Branch', provider: 'Provider', model: 'Model', tokens: 'Tokens',
  'context-usage': 'Context', 'sub-hourly': 'Session', 'sub-weekly': 'Weekly',
};
const identity = ['git-branch', 'provider', 'model'];
const telemetry = ['tokens', 'context-usage', 'sub-hourly', 'sub-weekly'];

function renderSegment(segment: Segment, theme: Colors): string {
  const parts = [theme.fg('muted', `${labels[segment.id] ?? segment.id} `)];
  if (segment.icon) parts.push(theme.fg('muted', segment.icon + ' '));
  if (segment.text) parts.push(theme.fg(segment.id === 'model' ? 'accent' : 'text', segment.text));
  if (typeof segment.bar === 'number' && Number.isFinite(segment.bar)) {
    const value = Math.max(0, Math.min(100, segment.bar));
    const filled = Math.round(value / 100 * 8);
    const color = value > 80 ? 'error' : value > 60 ? 'warning' : 'accent';
    // Foreground tracks, not dim-text used as a background: clear in both variants.
    parts.push(' ' + theme.fg(color, '━'.repeat(filled)) + theme.fg('border', '─'.repeat(8 - filled)));
  }
  if (segment.suffix) parts.push(' ' + theme.fg('text', segment.suffix));
  return parts.join('');
}

export function renderStatus(segments: Map<string, Segment>, theme: Colors, width: number): string[] {
  if (width < 1 || segments.size === 0) return [];
  const padding = width > 4 ? 1 : 0;
  const inner = width - padding * 2;
  const known = new Set([...identity, ...telemetry]);
  const groups = [identity, [...telemetry, ...[...segments.keys()].filter(id => !known.has(id))]];
  const result: string[] = [];
  for (const group of groups) {
    const parts = group.flatMap(id => segments.has(id) ? [renderSegment(segments.get(id)!, theme)] : []);
    if (!parts.length) continue;
    const row = parts.join(theme.fg('dim', '  ·  '));
    for (const line of wrapTextWithAnsi(row, inner)) {
      const fitted = truncateToWidth(line, inner, '');
      result.push(theme.bg('customMessageBg', ' '.repeat(padding) + fitted + ' '.repeat(width - padding - visibleWidth(fitted))));
    }
  }
  return result;
}

export function renderEditorBorder(theme: Colors, width: number, label: string, state: string): string {
  if (width < 1) return '';
  if (width < 24) return theme.fg('borderMuted', '─'.repeat(width));
  const left = theme.fg('accent', ` ${label} `);
  const right = theme.fg(state === 'Working' ? 'accent' : 'muted', ` ${state} `);
  const gap = Math.max(0, width - visibleWidth(left) - visibleWidth(right) - 2);
  return theme.fg('borderMuted', '─') + left + theme.fg('borderMuted', '─'.repeat(gap)) + right + theme.fg('borderMuted', '─');
}

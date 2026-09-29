import { CustomEditor, type ExtensionAPI, type ExtensionContext } from '@earendil-works/pi-coding-agent';
import type { TUI } from '@earendil-works/pi-tui';
import { renderEditorBorder, renderStatus, updateSegment, type Segment } from '../components/status.ts';

/** Presentation only. LazyPi's producers remain responsible for all live statistics. */
export default function zirconiumUI(pi: ExtensionAPI) {
  const segments = new Map<string, Segment>();
  let tui: TUI | undefined;
  let working = false;

  pi.events.on('powerbar:update', payload => {
    updateSegment(segments, payload);
    tui?.requestRender();
  });

  function install(ctx: ExtensionContext) {
    if (ctx.mode !== 'tui') return;
    working = false;
    ctx.ui.setWorkingIndicator({ frames: ['·', '∙', '•', '∙'], intervalMs: 200 });
    ctx.ui.setWidget('zirconium-status', (activeTui) => {
      tui = activeTui;
      return {
        render: width => renderStatus(segments, ctx.ui.theme, width),
        invalidate() {},
      };
    }, { placement: 'belowEditor' });
    // The replacement footer still exposes statuses published by other extensions.
    ctx.ui.setFooter((_tui, _theme, footerData) => ({
      render: width => {
        const statuses = [...footerData.getExtensionStatuses()];
        if (!statuses.length) return [];
        return renderStatus(new Map(statuses.map(([id, text]) => [id, { id, text }])), ctx.ui.theme, width);
      },
      invalidate() {},
    }));
    ctx.ui.setEditorComponent((activeTui, theme, keybindings) => {
      class ZirconiumEditor extends CustomEditor {
        protected renderTopBorder(width: number, hiddenLineCount: number): string {
          // Keep native scroll counts intact, and never overwrite completion rows.
          if (hiddenLineCount > 0) return super.renderTopBorder(width, hiddenLineCount);
          const label = this.getText().startsWith('!') ? 'Shell' : 'Prompt';
          return renderEditorBorder(ctx.ui.theme, width, label, working ? 'Working' : 'Ready');
        }
      }
      return new ZirconiumEditor(activeTui, theme, keybindings);
    });
  }

  pi.on('session_start', (_event, ctx) => install(ctx));
  pi.on('agent_start', () => { working = true; tui?.requestRender(); });
  pi.on('agent_settled', () => { working = false; tui?.requestRender(); });
  pi.on('session_shutdown', () => { tui = undefined; });
}

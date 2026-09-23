<script>
  import { onMount, tick } from 'svelte'
  import palette from './lib/palette.json'

  const assetBase = import.meta.env.BASE_URL
  const base = [
    { label: 'Background', group: 'surface', key: 'bg' },
    { label: 'Panel', group: 'surface', key: 'panel' },
    { label: 'Raised', group: 'surface', key: 'elevated' },
    { label: 'Border', group: 'surface', key: 'border' },
    { label: 'Text', group: 'text', key: 'primary' },
    { label: 'Muted text', group: 'text', key: 'muted' },
    { label: 'Accent', group: 'ui', key: 'accent' },
    { label: 'Selection', group: 'surface', key: 'selection' },
  ]
  const syntax = [
    { label: 'Keyword', key: 'keyword' },
    { label: 'String', key: 'string' },
    { label: 'Builtin', key: 'builtin' },
    { label: 'Comment', key: 'comment' },
    { label: 'Function', key: 'function' },
    { label: 'Literal', key: 'literal' },
    { label: 'Number', key: 'number' },
    { label: 'Type', key: 'type' },
  ]

  let mode = 'dark'
  let status = ''
  let statusTimer
  let fallbackText = ''
  let fallbackInput
  let copyTrigger
  $: p = palette[mode]
  $: baseColors = base.map(item => ({ ...item, value: p[item.group][item.key] }))
  $: syntaxColors = syntax.map(item => ({ ...item, value: p.syntax[item.key] }))
  $: ansiColors = [...p.ansi.normal, ...p.ansi.bright]

  onMount(() => {
    let saved
    try { saved = localStorage.getItem('zirconium-mode') } catch { /* storage unavailable */ }
    if (saved === 'light' || saved === 'dark') mode = saved
    else if (window.matchMedia?.('(prefers-color-scheme: light)').matches) mode = 'light'
    return () => clearTimeout(statusTimer)
  })

  function setMode(next) {
    mode = next
    try { localStorage.setItem('zirconium-mode', next) } catch { /* storage unavailable */ }
  }

  async function copyColor(value, label, event) {
    copyTrigger = event.currentTarget
    try {
      await navigator.clipboard.writeText(value)
      fallbackText = ''
      status = `${label} copied`
    } catch {
      fallbackText = value
      status = 'Clipboard unavailable — select the value below to copy'
      await tick()
      fallbackInput?.focus()
      fallbackInput?.select()
    }
    clearTimeout(statusTimer)
    statusTimer = setTimeout(() => status = '', 3000)
  }

  function closeFallback() {
    fallbackText = ''
    copyTrigger?.focus()
  }
</script>

<div class="site" style={`--page:${p.surface.bg};--panel:${p.surface.panel};--edge:${p.surface.border};--control-edge:${p.ui.controlBorder};--ink:${p.text.primary};--muted:${p.text.muted};--accent:${p.ui.accent};--selection:${p.surface.selection}`}>
  <a class="skip" href="#main">Skip to palette</a>
  <header class="masthead">
    <div class="shell masthead-inner">
      <div class="wordmark"><img src={`${assetBase}zirconium-mark.svg`} alt="" width="36" height="36"/><span>Zirconium</span></div>
      <div class="mode-toggle" role="group" aria-label="Palette appearance">
        <button type="button" aria-pressed={mode === 'dark'} on:click={() => setMode('dark')}>Dark</button>
        <button type="button" aria-pressed={mode === 'light'} on:click={() => setMode('light')}>Light</button>
      </div>
    </div>
  </header>

  <main id="main" class="shell">
    <section class="identity" aria-labelledby="page-title">
      <div class="element" role="img" aria-label="Periodic table tile: zirconium, atomic number 40">
        <span class="atomic-number" aria-hidden="true">40</span>
        <span class="element-symbol" aria-hidden="true">Zr</span>
        <span class="element-name" aria-hidden="true">Zirconium</span>
      </div>
      <div class="identity-copy">
        <p class="index">40 / Zr</p>
        <h1 id="page-title">Zirconium</h1>
        <p>Dark and light colors for Neovim and terminals.</p>
      </div>
    </section>

    <section class="color-section" aria-labelledby="base-heading">
      <div class="section-heading"><h2 id="base-heading">Base</h2><span>Select to copy</span></div>
      <div class="swatch-grid">
        {#each baseColors as item (item.label)}
          <button class="swatch" type="button" style={`--sample:${item.value}`} aria-label={`Copy ${mode} ${item.label} ${item.value}`} on:click={(event) => copyColor(item.value, item.label, event)}>
            <span class="swatch-color" aria-hidden="true"></span>
            <span class="swatch-info"><span>{item.label}</span><code>{item.value.toUpperCase()}</code></span>
          </button>
        {/each}
      </div>
    </section>

    <section class="color-section" aria-labelledby="syntax-heading">
      <div class="section-heading"><h2 id="syntax-heading">Syntax</h2></div>
      <div class="swatch-grid">
        {#each syntaxColors as item (item.label)}
          <button class="swatch" type="button" style={`--sample:${item.value}`} aria-label={`Copy ${mode} ${item.label} ${item.value}`} on:click={(event) => copyColor(item.value, item.label, event)}>
            <span class="swatch-color" aria-hidden="true"></span>
            <span class="swatch-info"><span>{item.label}</span><code>{item.value.toUpperCase()}</code></span>
          </button>
        {/each}
      </div>
    </section>

    <section class="color-section ansi-section" aria-labelledby="ansi-heading">
      <div class="section-heading"><h2 id="ansi-heading">ANSI 0–15</h2></div>
      <div class="ansi-grid">
        {#each ansiColors as value, index (index)}
          <button class="ansi-swatch" type="button" style={`--sample:${value}`} aria-label={`Copy ${mode} ANSI ${index} ${value}`} on:click={(event) => copyColor(value, `ANSI ${index}`, event)}>
            <span class="ansi-color" aria-hidden="true"></span>
            <span class="ansi-info"><span>{String(index).padStart(2, '0')}</span><code>{value.toUpperCase()}</code></span>
          </button>
        {/each}
      </div>
    </section>
  </main>

  <footer class="shell footer"><span>40 · Zr</span><a href="https://github.com/T-450/zirconium">Source &amp; install ↗</a></footer>
  <div class="status" role="status" aria-live="polite">{status}</div>
  {#if fallbackText}
    <div class="copy-fallback">
      <label for="copy-fallback-text">Select and copy this value (Ctrl+C / Cmd+C).</label>
      <textarea id="copy-fallback-text" readonly bind:this={fallbackInput} value={fallbackText} rows="1"></textarea>
      <button type="button" on:click={closeFallback}>Close</button>
    </div>
  {/if}
</div>

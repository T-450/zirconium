<script>
  import { onMount, tick } from 'svelte'
  import palette from './lib/palette.json'

  const assetBase = import.meta.env.BASE_URL
  const repoUrl = 'https://github.com/T-450/zirconium'
  const cloneCommand = `git clone ${repoUrl}.git ~/.local/share/zirconium`

  const roles = [
    { key: 'keyword', label: 'Keyword', sample: 'const · return' },
    { key: 'string', label: 'String', sample: '"make it work"' },
    { key: 'builtin', label: 'Builtin', sample: '@import' },
    { key: 'comment', label: 'Comment', sample: '// a quieter voice' },
    { key: 'function', label: 'Function', sample: 'main()' },
    { key: 'literal', label: 'Literal', sample: 'true · null' },
    { key: 'number', label: 'Number', sample: '42 · 0xff' },
    { key: 'type', label: 'Type', sample: 'u8 · void' },
  ]
  const platforms = ['Neovim', 'Alacritty', 'foot', 'kitty']
  const snippets = {
    Neovim: {
      dark: `-- Add to your lazy.nvim plugin list:\n{\n  'T-450/zirconium',\n  lazy = false, priority = 1000,\n  config = function()\n    vim.o.termguicolors = true\n    vim.cmd.colorscheme('zirconium-dark')\n  end,\n}`,
      light: `-- Add to your lazy.nvim plugin list:\n{\n  'T-450/zirconium',\n  lazy = false, priority = 1000,\n  config = function()\n    vim.o.termguicolors = true\n    vim.cmd.colorscheme('zirconium-light')\n  end,\n}`,
    },
    Alacritty: {
      dark: `[general]\nimport = ["~/.local/share/zirconium/terminal/alacritty/zirconium-dark.toml"]`,
      light: `[general]\nimport = ["~/.local/share/zirconium/terminal/alacritty/zirconium-light.toml"]`,
    },
    foot: {
      dark: `# ~/.config/foot/foot.ini (top-level section)\ninclude=~/.local/share/zirconium/terminal/foot/zirconium-dark.ini`,
      light: `# ~/.config/foot/foot.ini (top-level section)\ninclude=~/.local/share/zirconium/terminal/foot/zirconium-light.ini`,
    },
    kitty: {
      dark: `# ~/.config/kitty/kitty.conf\ninclude \${HOME}/.local/share/zirconium/terminal/kitty/zirconium-dark.conf`,
      light: `# ~/.config/kitty/kitty.conf\ninclude \${HOME}/.local/share/zirconium/terminal/kitty/zirconium-light.conf`,
    },
  }
  let mode = 'dark'
  let platform = 'Neovim'
  let toast = ''
  let toastTimer
  let fallbackText = ''
  let fallbackInput
  let copyTrigger
  $: p = palette[mode]
  $: snippet = snippets[platform][mode]

  onMount(() => {
    let saved
    try { saved = localStorage.getItem('zirconium-mode') } catch { /* storage unavailable */ }
    if (saved === 'light' || saved === 'dark') mode = saved
    else if (window.matchMedia?.('(prefers-color-scheme: light)').matches) mode = 'light'
    return () => clearTimeout(toastTimer)
  })
  function setMode(next) {
    mode = next
    try { localStorage.setItem('zirconium-mode', next) } catch { /* unavailable */ }
  }
  async function copy(text, label, event) {
    copyTrigger = event.currentTarget
    try {
      await navigator.clipboard.writeText(text)
      fallbackText = ''
      toast = `${label} copied to clipboard`
    } catch {
      fallbackText = text
      toast = 'Clipboard unavailable — select the text below to copy'
      await tick()
      fallbackInput?.focus()
      fallbackInput?.select()
    }
    clearTimeout(toastTimer)
    toastTimer = setTimeout(() => toast = '', 3000)
  }
  function closeFallback() {
    fallbackText = ''
    copyTrigger?.focus()
  }
</script>

<div class="site" class:light={mode === 'light'} style={`--page:${p.surface.bg};--panel:${p.surface.panel};--raised:${p.surface.elevated};--quiet:${p.surface.muted};--edge:${p.surface.border};--control-edge:${p.ui.controlBorder};--ink:${p.text.primary};--muted:${p.text.muted};--faint:${p.text.subtle};--accent:${p.ui.accent};--accent-ink:${p.text.inverse};--string:${p.syntax.string};--success:${p.diagnostic.success};--operator:${p.syntax.operator};--lavender:${p.syntax['function']};--coral:${p.syntax.builtin};--blue:${p.syntax.type};--highlight:${p.surface.selection}`}>
  <a class="skip" href="#main">Skip to content</a>
  <header class="site-header">
    <nav class="nav wrap" aria-label="Main navigation">
      <a class="brand" href="#top" aria-label="Zirconium, back to top"><img src={`${assetBase}zirconium-mark.svg`} alt="" width="34" height="34"/><span>ZIRCONIUM<span class="brand-dot">.</span></span></a>
      <div class="nav-links"><a href="#palette">Palette</a><a href="#philosophy">Philosophy</a><a href="#install">Get the theme</a></div>
      <div class="theme-switch" role="group" aria-label="Preview appearance">
        <button type="button" class:chosen={mode === 'dark'} aria-pressed={mode === 'dark'} on:click={() => setMode('dark')}>Dark</button>
        <button type="button" class:chosen={mode === 'light'} aria-pressed={mode === 'light'} on:click={() => setMode('light')}>Light</button>
      </div>
    </nav>
  </header>

  <main id="main">
    <section id="top" class="hero wrap">
      <div class="hero-copy">
        <div class="eyebrow"><span class="eyebrow-rule"></span> THE WORKING PALETTE <span class="eyebrow-index">/ 01</span></div>
        <h1>Color with a<br/><em>working purpose.</em></h1>
        <p class="lead">A considered color system for the spaces where you actually build. One language across your editor and terminal. Two conditions of light.</p>
        <div class="hero-actions"><a class="button primary" href="#install">Make it yours <span aria-hidden="true">↗</span></a><a class="button ghost" href="#palette">Explore the palette <span aria-hidden="true">↓</span></a></div>
        <div class="hero-meta"><span><span class="status-dot"></span> NEOVIM · ALACRITTY · FOOT · KITTY</span><span>TRUECOLOR / 256-COLOR FALLBACK IN NVIM</span></div>
      </div>
      <div class="hero-visual" role="img" aria-label={`${mode} editor and terminal color preview`}>
        <div class="preview-top"><span class="window-dots" aria-hidden="true"><i></i><i></i><i></i></span><span>zirconium / workspace</span><span class="preview-mode">{mode.toUpperCase()} MODE</span></div>
        <div class="editor-preview"><div class="filebar"><span><span class="file-icon">Z</span> src/main.zig</span><span>zig · utf-8</span></div>
          <div class="code-lines" aria-hidden="true">
            <div><span class="line-num">01</span><span style={`color:${p.syntax.comment}`} class="italic">// Find the signal.</span></div>
            <div><span class="line-num">02</span><span style={`color:${p.syntax.keyword}`} class="bold">const</span> std <span class="operator">=</span> <span style={`color:${p.syntax.builtin}`}>@import</span>(<span style={`color:${p.syntax.string}`}>&quot;std&quot;</span>);</div>
            <div><span class="line-num">03</span></div>
            <div><span class="line-num">04</span><span style={`color:${p.syntax.keyword}`} class="bold">pub fn</span> <span style={`color:${p.syntax['function']}`} class="bold">main</span>() <span style={`color:${p.syntax.type}`} class="bold">void</span> {'{'}</div>
            <div><span class="line-num">05</span>  <span style={`color:${p.syntax.keyword}`} class="bold">const</span> answer: <span style={`color:${p.syntax.type}`} class="bold">u8</span> <span class="operator">=</span> <span style={`color:${p.syntax.number}`}>42</span>;</div>
            <div><span class="line-num">06</span>  std.debug.<span style={`color:${p.syntax['function']}`} class="bold">print</span>(<span style={`color:${p.syntax.string}`}>&quot;hello, {'{d}'}\n&quot;</span>, .{'{'}answer{'}'});</div>
            <div><span class="line-num">07</span>{'}'}</div>
          </div><div class="editor-status"><span>NORMAL</span><span>main.zig</span><span>zig · 7 lines</span></div>
        </div>
        <div class="shell-preview"><span class="shell-prompt">~ ❯</span> nvim src/main.zig <span class="shell-cursor" aria-hidden="true"></span><div><span class="shell-success">✓</span> ANSI 0–15 from the shared palette.</div></div>
        <div class="preview-foot"><span>DESIGNED TO DISAPPEAR INTO THE WORK</span><span>FIG. 01 — {mode.toUpperCase()}</span></div>
      </div>
    </section>

    <div class="ticker" aria-hidden="true"><div class="ticker-inner"><span>LESS DECORATION / MORE ORIENTATION</span><b>✳</b><span>THE SAME SIGNAL IN EVERY WINDOW</span><b>✳</b><span>BUILT FOR BOTH SIDES OF THE DAY</span><b>✳</b></div></div>

    <section id="palette" class="section wrap palette-section">
      <div class="section-intro"><div><div class="eyebrow">02 / THE COLOR LANGUAGE</div><h2>Every shade<br/>has a job.</h2></div><p>Syntax should tell you what matters, not compete for attention. The reference shapes the voice; practical contrast gives it staying power. Select a color to copy its value.</p></div>
      <div class="palette-grid">
        {#each roles as role}
          <button type="button" class="swatch" on:click={(event) => copy(p.syntax[role.key], `${role.label} ${p.syntax[role.key]}`, event)} aria-label={`Copy ${mode} ${role.label} color ${p.syntax[role.key]}`}>
            <span class="swatch-visual" style={`background:${p.syntax[role.key]}`} aria-hidden="true"><span class="swatch-symbol">↗</span></span>
            <span class="swatch-info"><span>{role.label}</span><code>{p.syntax[role.key].toUpperCase()}</code></span><span class="swatch-sample" style={`color:${p.syntax[role.key]}`}>{role.sample}</span>
          </button>
        {/each}
      </div>
      <div class="palette-caption"><span>01 — {mode.toUpperCase()} / ZIRCONIUM</span><span>8 CORE SYNTAX ROLES · COMPLETE UI + ANSI SYSTEM</span></div>
    </section>

    <section id="philosophy" class="section philosophy">
      <div class="wrap philosophy-inner"><div><div class="eyebrow">03 / THE THINKING</div><h2>Designed for<br/><em>the long session.</em></h2><p class="philosophy-lead">Not a coat of paint. A dependable instrument panel for people who live in the terminal.</p></div>
      <div class="principles">
        <article><span class="principle-num">01 /</span><div><h3>Keep the hierarchy honest.</h3><p>Keywords carry structure. Functions and types step forward. Comments stay readable without claiming the room.</p></div></article>
        <article><span class="principle-num">02 /</span><div><h3>Let every tool speak the same language.</h3><p>Editor, terminal and command output share surfaces and signals. A context switch should not feel like a palette switch.</p></div></article>
        <article><span class="principle-num">03 /</span><div><h3>Build for changing light.</h3><p>Graphite for focus, warm paper for daylight. Different values, the same intent and roles.</p></div></article>
      </div></div>
    </section>

    <section class="section wrap system-section"><div class="section-intro"><div><div class="eyebrow">04 / IN YOUR WORKSPACE</div><h2>One palette.<br/>Four places.</h2></div><p>Theme the full loop—from writing code to running it. Carefully mapped for each application's own color format.</p></div>
      <div class="app-grid"><div><span>01</span><strong>Neovim</strong><small>EDITOR / LUA</small></div><div><span>02</span><strong>Alacritty</strong><small>TERMINAL / TOML</small></div><div><span>03</span><strong>foot</strong><small>TERMINAL / INI</small></div><div><span>04</span><strong>kitty</strong><small>TERMINAL / CONF</small></div></div>
      <div class="terminal-preview"><div class="terminal-preview-head"><span>ALACRITTY / FOOT / KITTY</span><span>ANSI 0–15 · {mode.toUpperCase()}</span></div>
        <p>One generated terminal ramp, exported to all three formats.</p>
        <div class="ansi-ramp" role="img" aria-label={`${mode} terminal ANSI colors 0 through 15`}>
          {#each [...p.ansi.normal, ...p.ansi.bright] as color, index}
            <span class="ansi-chip" title={`ANSI ${index}: ${color}`}><span style={`background:${color}`}></span><small>{String(index).padStart(2, '0')}</small></span>
          {/each}
        </div>
      </div>
    </section>

    <section id="install" class="section install-section"><div class="wrap install-inner"><div class="install-copy"><div class="eyebrow">05 / PUT IT TO WORK</div><h2>Your setup,<br/><em>in your hands.</em></h2><p>Install the Neovim plugin from GitHub, or clone the repository once for Alacritty, foot and kitty. See the <a href={repoUrl}>repository README</a> and <a href={`${repoUrl}/blob/main/terminal/README.md`}>terminal instructions</a> for full configuration details.</p><div class="install-note"><span>↳</span> Choose an appearance and app. For terminals, run the clone command first, then add the matching import to your config file.</div></div>
      <div class="install-window"><div class="install-header"><div class="tabs" role="group" aria-label="Choose application">{#each platforms as item}<button type="button" class:active={platform === item} aria-pressed={platform === item} on:click={() => platform = item}>{item}</button>{/each}</div></div>
        {#if platform !== 'Neovim'}
          <div class="install-content clone-step"><div class="install-label"><span>1 / CLONE THE REPOSITORY</span><button type="button" on:click={(event) => copy(cloneCommand, 'Clone command', event)} aria-label="Copy terminal theme clone command">COPY ↗</button></div><pre><code>{cloneCommand}</code></pre></div>
        {/if}
        <div class="install-content"><div class="install-label"><span>{platform === 'Neovim' ? 'LAZY.NVIM PLUGIN SPEC' : '2 / CONFIG IMPORT'} · {mode.toUpperCase()}</span><button type="button" on:click={(event) => copy(snippet, `${platform} snippet`, event)} aria-label={`Copy ${platform} ${mode} installation snippet`}>COPY ↗</button></div><pre><code>{snippet}</code></pre></div><div class="install-bottom">KEEP THE PALETTE IN ONE PLACE. <span>→</span></div></div></div>
    </section>
  </main>
  <footer class="footer wrap"><div class="footer-brand"><img src={`${assetBase}zirconium-mark.svg`} width="30" height="30" alt=""/><span>ZIRCONIUM.</span></div><p>Color with a working purpose.<br/>Inspired by a Zig Docs reference; not an official Zig project.</p><a href="#top">BACK TO TOP ↑</a></footer>
  <div class="toast" class:visible={toast !== ''} role="status" aria-live="polite">{toast}</div>
  {#if fallbackText}
    <div class="copy-fallback"><label for="copy-fallback-text">Clipboard unavailable. Selected text can be copied with Ctrl+C / Cmd+C.</label><textarea id="copy-fallback-text" readonly bind:this={fallbackInput} value={fallbackText} rows={fallbackText.includes('\n') ? 5 : 1}></textarea><button type="button" on:click={closeFallback}>Close</button></div>
  {/if}
</div>

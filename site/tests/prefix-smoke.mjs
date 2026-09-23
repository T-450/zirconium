import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { createServer } from 'node:http';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const dist = resolve(dirname(fileURLToPath(import.meta.url)), '../dist');
const prefix = '/zirconium/';
const outsideRequests = [];
const server = createServer(async (request, response) => {
  const pathname = new URL(request.url, 'http://localhost').pathname;
  if (!pathname.startsWith(prefix)) {
    outsideRequests.push(pathname);
    response.writeHead(404).end();
    return;
  }
  const relative = pathname.slice(prefix.length) || 'index.html';
  if (relative.split('/').includes('..')) {
    response.writeHead(400).end();
    return;
  }
  try {
    const content = await readFile(resolve(dist, relative));
    response.writeHead(200).end(content);
  } catch {
    response.writeHead(404).end();
  }
});

await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
try {
  const base = `http://127.0.0.1:${server.address().port}${prefix}`;
  const html = await (await fetch(base)).text();
  const socialImage = html.match(/<meta property="og:image" content="([^"]+)"/)?.[1];
  assert.equal(socialImage, 'https://t-450.github.io/zirconium/zirconium-social.svg');
  const assets = [...html.matchAll(/(?:src|href)="([^" ]+\.(?:js|css|svg))"/g)].map(match => match[1]);
  assert(assets.some(path => path.endsWith('.js')) && assets.some(path => path.endsWith('.css')));
  assert(assets.some(path => path.endsWith('zirconium-mark.svg')));
  assets.push('zirconium-social.svg');
  for (const asset of assets) {
    const url = new URL(asset, base);
    assert(url.pathname.startsWith(prefix), `${asset} escapes ${prefix}`);
    const result = await fetch(url);
    assert.equal(result.status, 200, `${asset} failed under ${prefix}`);
    if (asset.endsWith('.css')) {
      const css = await result.text();
      const fonts = [...css.matchAll(/url\(["']?([^"')]+\.woff2)["']?\)/g)].map(match => match[1]);
      assert.equal(fonts.length, 2);
      for (const font of fonts) {
        const fontUrl = new URL(font, url);
        assert(fontUrl.pathname.startsWith(prefix), `${font} escapes ${prefix}`);
        assert.equal((await fetch(fontUrl)).status, 200, `${font} failed under ${prefix}`);
      }
    }
  }
  assert.deepEqual(outsideRequests, []);
  console.log('Prefix smoke: HTML, JS, CSS, icon, social image, both fonts served under /zirconium/');
} finally {
  server.close();
}

#!/usr/bin/env node
// File: scripts/panelParity.js
//
// Panel PARITY check: does the Merit Wallet render the same panels in the web
// app and in the extension?
//
// WHY THIS EXISTS (2026-10-03). Both apps are supposed to render the same
// node_source panels, but each tab body was composed twice — once in the web
// app (components/views/...) and once as a "portable placeholder" in
// @sponsorcoin/spcoin-panels — and the two drifted: the extension showed a 0x
// button while Uniswap was selected, had no Uniswap section, no fee disclosure,
// hard-coded "Balance: 0". Nothing noticed, because nothing compared them. This
// does: for every tab it lists what each app actually renders and prints the
// difference. Run it after any change to a panel and treat a new difference as a
// bug unless it is listed in HOST_ONLY below.
//
// WHAT IT COMPARES, per tab (Swap, Send, Sponsor, Rewards, Config)
// and the Panel Tree view (a main-radio overlay opened from the
// Config tab's "Open Panel Tree" button, not a tab of its own):
//   1. Panel gates:  every [data-panel] element that is visible (PanelGate).
//   2. Visible text: the tab body's own lines (balances, build stamps and the
//      per-component path markers are stripped — they legitimately differ).
// Gates catch a panel that is missing or shown when its flag says hidden; text
// catches UNGATED content (e.g. a stray button) that gates cannot see.
//
// PanelTree must run LAST (it is moved there automatically): the view
// replaces the wallet body — the tab strip is gone while it is open and
// only the title bar's back arrow returns to Config, which this probe
// does not click.
//
// USAGE
//   node scripts/panelParity.js [--web http://localhost:3000] [--ext spCoinExtension/deploy]
//                               [--chrome <path-to-chrome.exe>] [--tabs Swap,Send]
//   Needs `playwright-core` (npm i -D playwright-core) and a Chromium/Chrome:
//   --chrome, or $CHROME, or the newest ~/AppData/Local/ms-playwright/chromium-*.
//   The web app must be running (`npm run dev`); build the extension first
//   (`cd spCoinExtension && npm run build`) so --ext points at a fresh build.
//   The wallet is unlocked for the web app by flipping the gate flag through
//   webpack's module cache in the TEST BROWSER only — nothing in the repo changes.
//   Exit code: 0 = no unexpected difference, 1 = parity gap, 2 = could not run.

const fs = require('fs');
const os = require('os');
const path = require('path');

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, all) => (a.startsWith('--') ? [...acc, [a.slice(2), all[i + 1] && !all[i + 1].startsWith('--') ? all[i + 1] : true]] : acc), []),
);
const ROOT = path.resolve(__dirname, '..');
const WEB_URL = args.web || 'http://localhost:3000';
const EXT_DIR = path.resolve(ROOT, args.ext || 'spCoinExtension/deploy');
const TABS = String(args.tabs || 'Swap,Send,Sponsor,Rewards,Config,PanelTree').split(',');
// The Panel Tree view replaces the wallet body, so it can only be the
// last step — move it there even when --tabs lists it elsewhere.
const treeIdx = TABS.indexOf('PanelTree');
if (treeIdx >= 0 && treeIdx !== TABS.length - 1) {
  TABS.splice(treeIdx, 1);
  TABS.push('PanelTree');
}

// Differences that are the HOST's business, not a parity gap.
//  - MERIT_WALLET: the web page wraps the wallet in its own MERIT_WALLET gate
//    (components/views/MeritWallet.tsx); the extension IS the wallet.
const HOST_ONLY_GATES = new Set(['MERIT_WALLET']);
// Lines that legitimately differ (live data, dev stamps).
const IGNORE_LINE = [/\.tsx/, /\bbuild \d+/i, /^Balance:/, /Balance:\s/, /^\(?@sponsorcoin/, /^\d[\d.,]*$/];

function findChrome() {
  if (args.chrome && fs.existsSync(args.chrome)) return args.chrome;
  if (process.env.CHROME && fs.existsSync(process.env.CHROME)) return process.env.CHROME;
  const base = path.join(os.homedir(), 'AppData', 'Local', 'ms-playwright');
  if (fs.existsSync(base)) {
    const dirs = fs.readdirSync(base).filter((d) => /^chromium-\d+$/.test(d)).sort().reverse();
    for (const d of dirs) {
      const exe = path.join(base, d, 'chrome-win64', 'chrome.exe');
      if (fs.existsSync(exe)) return exe;
    }
  }
  return undefined;
}

let chromium;
try {
  ({ chromium } = require('playwright-core'));
} catch {
  console.error('panelParity: playwright-core is not installed (npm i -D playwright-core).');
  process.exit(2);
}
const CHROME = findChrome();
if (!CHROME) {
  console.error('panelParity: no Chromium found; pass --chrome <path> or set $CHROME.');
  process.exit(2);
}
if (!fs.existsSync(path.join(EXT_DIR, 'manifest.json'))) {
  console.error(`panelParity: no built extension at ${EXT_DIR} (run "npm run build" in spCoinExtension).`);
  process.exit(2);
}

const clickTab = async (page, name) => {
  await page.evaluate((n) => {
    // PanelTree is a main-radio overlay opened by the Config tab's
    // button, not a tab strip button.
    const label = n === 'PanelTree' ? 'Open Panel Tree' : n;
    const b = [...document.querySelectorAll('button')].find((x) => x.textContent.trim() === label && x.getClientRects().length);
    if (b) b.click();
  }, name);
  await page.waitForTimeout(2500);
};

const snapshot = (page) =>
  page.evaluate(() => {
    const gates = [...document.querySelectorAll('[data-panel]')]
      .filter((e) => e.dataset.visible === 'true' && e.getClientRects().length > 0 && getComputedStyle(e).visibility !== 'hidden')
      .map((e) => e.dataset.panel);
    // The tab body: the scrolling region under the tab strip, the
    // Panel Tree view's own scroll region while it is open (the tab
    // strip is unmounted then), else the wallet root.
    const tree = document.querySelector('#PanelTreePanel');
    const body = (tree && tree.getClientRects().length > 0)
      ? tree
      : (document.querySelector('[data-panel="WALLET_RADIO_PANELS"]') || document.body);
    const lines = body.innerText.split('\n').map((l) => l.trim()).filter(Boolean);
    return { gates: [...new Set(gates)], lines };
  });

const cleanLines = (lines) => lines.filter((l) => !IGNORE_LINE.some((re) => re.test(l)));

async function collectWeb() {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const page = await browser.newPage({ viewport: { width: 1600, height: 1000 } });
  await page.goto(`${WEB_URL}/Test`, { waitUntil: 'domcontentloaded', timeout: 180000 });
  await page.waitForFunction(() => /build \d+/.test(document.body.innerText), null, { timeout: 180000 });
  await page.waitForTimeout(8000);
  // Unlock for the test browser only (see header). The wallet gate is a module-level
  // flag and the app re-asserts it over time, so it is re-applied before EVERY tab.
  const unlock = () => page.evaluate(() => {
    (window.webpackChunk_N_E = window.webpackChunk_N_E || []).push([[Symbol('parity')], {}, (req) => {
      for (const id of Object.keys(req.c || {})) {
        const ex = req.c[id] && req.c[id].exports;
        if (ex && typeof ex.setWalletGateOpen === 'function') ex.setWalletGateOpen(false);
      }
    }]);
  });
  const out = {};
  for (const t of TABS) { await unlock(); await clickTab(page, t); out[t] = await snapshot(page); }
  await browser.close();
  return out;
}

async function collectExtension() {
  const profile = fs.mkdtempSync(path.join(os.tmpdir(), 'panelParity-'));
  const ctx = await chromium.launchPersistentContext(profile, {
    executablePath: CHROME,
    headless: false, // new headless (below) is what supports extensions
    args: ['--headless=new', `--disable-extensions-except=${EXT_DIR}`, `--load-extension=${EXT_DIR}`],
    viewport: { width: 380, height: 900 },
  });
  const sw = ctx.serviceWorkers()[0] || (await ctx.waitForEvent('serviceworker', { timeout: 20000 }));
  const page = await ctx.newPage();
  await page.goto(`chrome-extension://${new URL(sw.url()).host}/sidepanel.html`);
  await page.waitForTimeout(8000);
  const out = {};
  for (const t of TABS) { await clickTab(page, t); out[t] = await snapshot(page); }
  await ctx.close();
  try { fs.rmSync(profile, { recursive: true, force: true }); } catch { /* temp dir, best effort */ }
  return out;
}

(async () => {
  console.log(`web:       ${WEB_URL}\nextension: ${EXT_DIR}\nchrome:    ${CHROME}\n`);
  const [web, ext] = [await collectWeb(), await collectExtension()];
  let gaps = 0;
  for (const t of TABS) {
    const wg = new Set(web[t].gates.filter((g) => !HOST_ONLY_GATES.has(g)));
    const eg = new Set(ext[t].gates.filter((g) => !HOST_ONLY_GATES.has(g)));
    const gateOnlyWeb = [...wg].filter((g) => !eg.has(g));
    const gateOnlyExt = [...eg].filter((g) => !wg.has(g));
    const wl = new Set(cleanLines(web[t].lines));
    const el = new Set(cleanLines(ext[t].lines));
    const textOnlyWeb = [...wl].filter((l) => !el.has(l));
    const textOnlyExt = [...el].filter((l) => !wl.has(l));
    const n = gateOnlyWeb.length + gateOnlyExt.length + textOnlyWeb.length + textOnlyExt.length;
    gaps += n;
    console.log(`== ${t}: ${n === 0 ? 'MATCH' : n + ' difference(s)'}  (gates web ${wg.size} / ext ${eg.size})`);
    if (gateOnlyWeb.length) console.log('   gates only in WEB :', gateOnlyWeb.join(', '));
    if (gateOnlyExt.length) console.log('   gates only in EXT :', gateOnlyExt.join(', '));
    if (textOnlyWeb.length) console.log('   text  only in WEB :', JSON.stringify(textOnlyWeb));
    if (textOnlyExt.length) console.log('   text  only in EXT :', JSON.stringify(textOnlyExt));
  }
  console.log(gaps === 0 ? '\nPARITY: no unexpected difference.' : `\nPARITY GAP: ${gaps} difference(s) above.`);
  process.exit(gaps === 0 ? 0 : 1);
})().catch((e) => {
  console.error('panelParity: failed to run:', e.message);
  process.exit(2);
});

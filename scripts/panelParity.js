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
//   --show <text>  also prints, for every tab and both apps, the visible lines that contain <text> (to see WHY a line differs).
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
// 2026-10-09 -- differences that are the HOST's business or only the PROBE's state, listed so a REAL gap stands out:
//  STATE: the web probe has no active account (its wallet is locked), the extension probe has one, so the web shows Connect where the extension shows the action
//    button, and balances / counts differ.
//  HOST-ONLY: the web's dev tooling (Shared Libraries, Check Drift, the node_source sync button); "Select an account first." is the shared Wallet Security section's hint, shown only while the web probe has no active account (state); the extension's own
//    vault features (Delete Wallet, Reveal Secret Recovery Phrase, the Open target Options).
const HOST_ONLY_LINE = [
  /^Connect$/, /^Swap via Uniswap V3$/, /^Enter Amount & Select Recipient$/, /^Select Trading Pair$/, /^Sell Token Required$/, /^Sponsor Staked spCoins:/,
  /standard test accounts .* (are|is) in the (keystore|vault)/i,
  /^Select Account:$/, /^Select an account first\.$/, /^Shared Libraries \(dev\)$/, /^One click: syncs node_source/, /^Check Drift$/, /^Sync node_source/,
  /^Backup file$/, /^A backup file holds every account of this wallet/, /^Back up to a file$/, /^To restore a backup, remove this wallet first/,
  /^Delete Wallet$/, /^Options$/, /^Local$/, /^Which site the Open button/, /^Reveal$/, /^Security — Reveal Secret Recovery Phrase$/, /^The phrase restores every account/,
  /^.+ — 0x[0-9a-fA-F]{40}$/,
  // the Config tab's "Who signs" section states which holder signs for the ACTIVE account: state, not layout (the probe has an account in one host and none in the other)
  // a wallet is named by where it runs (createWalletAccountDesign section 3): the web's main list is the dev keystore, the extension's list its own vault
  /^Merit Wallet \((Web Dev Server|Extension|Web)\)$/i,
  /^Who signs$/, /signs for this account/, /^Select an account to see who signs for it\.$/, /^Reading who signs for this account/,
];
const STATE_ONLY_GATES = new Set(['SPONSOR_CONNECT_TRADE_BUTTON']);

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
  await page.waitForTimeout(3000);
  // The vault is the wallet (setup is required by default), so the probe needs one: create it with the Hardhat phrase, as the web side's wallet has the Hardhat accounts.
  await page.evaluate(() => chrome.runtime.sendMessage({ type: 'merit/vault/create', password: 'password-1', mnemonic: 'test test test test test test test test test test test junk' }));
  await page.reload();
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
    const wg = new Set(web[t].gates.filter((g) => !HOST_ONLY_GATES.has(g) && !STATE_ONLY_GATES.has(g)));
    const eg = new Set(ext[t].gates.filter((g) => !HOST_ONLY_GATES.has(g) && !STATE_ONLY_GATES.has(g)));
    const gateOnlyWeb = [...wg].filter((g) => !eg.has(g));
    const gateOnlyExt = [...eg].filter((g) => !wg.has(g));
    const wl = new Set(cleanLines(web[t].lines).filter((l) => !HOST_ONLY_LINE.some((re) => re.test(l))));
    const el = new Set(cleanLines(ext[t].lines).filter((l) => !HOST_ONLY_LINE.some((re) => re.test(l))));
    if (args.show) for (const [side, set] of [['web', wl], ['ext', el]]) for (const l of set) if (l.toLowerCase().includes(String(args.show).toLowerCase())) console.log(`   [${t} ${side}] ${l}`);
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

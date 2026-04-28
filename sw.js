// 75cm — minimal offline-first service worker
const CACHE = '75cm-v1';
const ASSETS = [
  './',
  '75cm.html',
  'vacuum.html',
  'manifest.json'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;

  // Network-first for same-origin HTML so updates flow
  const url = new URL(req.url);
  const sameOrigin = url.origin === self.location.origin;
  const isHTML = req.headers.get('accept')?.includes('text/html');

  if (sameOrigin && isHTML) {
    e.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copy));
          return res;
        })
        .catch(() => caches.match(req).then((m) => m || caches.match('75cm.html')))
    );
    return;
  }

  // Cache-first for everything else
  e.respondWith(
    caches.match(req).then((hit) => hit || fetch(req).then((res) => {
      if (sameOrigin && res.ok) {
        const copy = res.clone();
        caches.open(CACHE).then((c) => c.put(req, copy));
      }
      return res;
    }).catch(() => hit))
  );
});

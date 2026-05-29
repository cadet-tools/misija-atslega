// Operācija Atslēga — GitHub Pages v2
// Iepriekšējā versija kešoja HTML/JS un varēja rādīt vecu, sabojātu kodu.
// Šī versija notīra veco kešu un ļauj lapai vienmēr ielādēt aktuālos failus.
self.addEventListener('install', event => {
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(fetch(event.request));
});

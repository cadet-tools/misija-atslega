const CACHE='op-atslega-github-v1';
const FILES=['./','./index.html','./admin.html','./manifest.json','./supabase-config.js'];

self.addEventListener('install',e=>{
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(FILES)).then(()=>self.skipWaiting()));
});

self.addEventListener('activate',e=>{
  e.waitUntil(
    caches.keys()
      .then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
      .then(()=>self.clients.claim())
  );
});

self.addEventListener('fetch',e=>{
  const req=e.request;
  const url=new URL(req.url);

  // Supabase/CDN pieprasījumus nekešo, lai konfigurācija un bildes/progress vienmēr būtu svaigi.
  if(req.method!=='GET' || url.origin!==self.location.origin){
    e.respondWith(fetch(req));
    return;
  }

  e.respondWith(
    caches.match(req).then(cached=>{
      const network=fetch(req).then(res=>{
        const clone=res.clone();
        caches.open(CACHE).then(c=>c.put(req,clone));
        return res;
      }).catch(()=>cached);
      return cached||network;
    })
  );
});

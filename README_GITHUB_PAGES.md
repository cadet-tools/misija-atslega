# Operācija Atslēga — GitHub Pages variants

Šis variants darbojas bez Netlify. Lapa ir statiska GitHub Pages lapa, bet dati un bildes glabājas Supabase.

## 1. Supabase

1. Atver Supabase projektu.
2. SQL Editor palaid `SUPABASE_SETUP_GITHUB.sql`.
3. Authentication → Users izveido vienu admin lietotāju ar e-pastu un paroli.
4. Project Settings → API nokopē:
   - Project URL
   - anon public key vai publishable key

## 2. Aizpildi `supabase-config.js`

```js
window.OPATSLEGA_SUPABASE_URL = "https://xxxxx.supabase.co";
window.OPATSLEGA_SUPABASE_ANON_KEY = "tava_anon_vai_publishable_key";
window.OPATSLEGA_BUCKET = "mission-images";
window.OPATSLEGA_MISSION_ID = "default";
```

Neliec šeit `service_role`, `sb_secret_...` vai jebkādu slepeno atslēgu.

## 3. GitHub repo struktūra

Repo saknē jābūt:

```text
index.html
admin.html
sw.js
manifest.json
supabase-config.js
SUPABASE_SETUP_GITHUB.sql
.nojekyll
```

## 4. Ieslēdz GitHub Pages

1. GitHub repo → Settings → Pages.
2. Build and deployment → Source: Deploy from a branch.
3. Branch: `main`, folder: `/root`.
4. Save.

Pēc publicēšanas skolēna lapa būs apmēram:

```text
https://cadet-tools.github.io/misija-atslega/
```

Admin panelis:

```text
https://cadet-tools.github.io/misija-atslega/admin.html
```

## 5. Lietošana

1. Atver `admin.html`.
2. Ievadi Supabase Auth admin e-pastu un paroli.
3. Sagatavo KP, bildes un trases.
4. Spied Saglabāt.
5. Skolēni atver `index.html` un redz tās pašas bildes no Supabase.

## Svarīgi

Tā kā GitHub Pages neatbalsta servera kodu, drošība balstās uz Supabase RLS politikām. Admin konfigurācijas maiņa atļauta tikai pieslēgtam Supabase Auth lietotājam.

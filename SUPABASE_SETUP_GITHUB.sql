-- Operācija Atslēga — GitHub Pages + Supabase variants
-- Palaid Supabase SQL Editor vienu reizi.

create table if not exists public.mission_config (
  id text primary key default 'default',
  kps jsonb not null default '[]'::jsonb,
  routes jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.mission_progress (
  mission_id text not null default 'default',
  group_name text not null,
  route_idx int not null default 0,
  done jsonb not null default '[]'::jsonb,
  ts bigint,
  updated_at timestamptz not null default now(),
  primary key (mission_id, group_name, route_idx)
);

alter table public.mission_config enable row level security;
alter table public.mission_progress enable row level security;

-- Ja palaiž atkārtoti, noņem vecās politikas
DROP POLICY IF EXISTS "mission_config anon read" ON public.mission_config;
DROP POLICY IF EXISTS "mission_config admin insert" ON public.mission_config;
DROP POLICY IF EXISTS "mission_config admin update" ON public.mission_config;
DROP POLICY IF EXISTS "mission_config admin delete" ON public.mission_config;
DROP POLICY IF EXISTS "mission_progress anon read" ON public.mission_progress;
DROP POLICY IF EXISTS "mission_progress anon insert" ON public.mission_progress;
DROP POLICY IF EXISTS "mission_progress anon update" ON public.mission_progress;
DROP POLICY IF EXISTS "mission_progress admin delete" ON public.mission_progress;

-- Skolēni drīkst lasīt spēles konfigurāciju
CREATE POLICY "mission_config anon read"
ON public.mission_config
FOR SELECT
TO anon, authenticated
USING (true);

-- Tikai pieslēdzies admin lietotājs drīkst mainīt konfigurāciju
CREATE POLICY "mission_config admin insert"
ON public.mission_config
FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "mission_config admin update"
ON public.mission_config
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "mission_config admin delete"
ON public.mission_config
FOR DELETE
TO authenticated
USING (true);

-- Progress: skolēni drīkst saglabāt savu progresu, admin drīkst lasīt
CREATE POLICY "mission_progress anon read"
ON public.mission_progress
FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "mission_progress anon insert"
ON public.mission_progress
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "mission_progress anon update"
ON public.mission_progress
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "mission_progress admin delete"
ON public.mission_progress
FOR DELETE
TO authenticated
USING (true);

-- Storage bucket bildēm
insert into storage.buckets (id, name, public)
values ('mission-images', 'mission-images', true)
on conflict (id) do update set public = true;

DROP POLICY IF EXISTS "mission images public read" ON storage.objects;
DROP POLICY IF EXISTS "mission images admin insert" ON storage.objects;
DROP POLICY IF EXISTS "mission images admin update" ON storage.objects;
DROP POLICY IF EXISTS "mission images admin delete" ON storage.objects;

CREATE POLICY "mission images public read"
ON storage.objects
FOR SELECT
TO anon, authenticated
USING (bucket_id = 'mission-images');

CREATE POLICY "mission images admin insert"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'mission-images');

CREATE POLICY "mission images admin update"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'mission-images')
WITH CHECK (bucket_id = 'mission-images');

CREATE POLICY "mission images admin delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'mission-images');

-- Sākuma dati, lai lapa nepaliek tukša
insert into public.mission_config (id, kps, routes)
values (
  'default',
  '[
    {"name":"KP 1","code":"1111","fragment":"47-A","hint":"Meklējiet šajā apkārtnē!","img":""},
    {"name":"KP 2","code":"2222","fragment":"83-B","hint":"Fragments paslēpts netālu.","img":""},
    {"name":"KP 3","code":"3333","fragment":"19-C","hint":"Lūkojieties uzmanīgi!","img":""},
    {"name":"KP 4","code":"4444","fragment":"62-D","hint":"Fragments ir 10 m rādiusā.","img":""},
    {"name":"KP 5","code":"5555","fragment":"35-E","hint":"Pārmeklējiet šo zonu.","img":""},
    {"name":"KP 6","code":"6666","fragment":"74-F","hint":"Fragments paslēpts tuvumā.","img":""},
    {"name":"KP 7","code":"7777","fragment":"28-G","hint":"Meklējiet!","img":""},
    {"name":"KP 8","code":"8888","fragment":"91-H","hint":"Fragments ir šeit netālu.","img":""},
    {"name":"KP 9","code":"9999","fragment":"56-I","hint":"Rūpīgi aplūkojiet apkārtni.","img":""},
    {"name":"KP 10","code":"0000","fragment":"13-J","hint":"Pēdējais fragments!","img":""}
  ]'::jsonb,
  '[
    {"name":"Trase A","desc":"KP 1 → KP 10","order":[0,1,2,3,4,5,6,7,8,9]},
    {"name":"Trase B","desc":"KP 10 → KP 1","order":[9,8,7,6,5,4,3,2,1,0]}
  ]'::jsonb
)
on conflict (id) do nothing;

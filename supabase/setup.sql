-- ProjectHub database setup for Supabase.
-- Run this entire script in Supabase Dashboard > SQL Editor > New query.

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null,
  category text not null default 'Data Analysis',
  tags text[] not null default '{}',
  status text not null default 'Draft' check (status in ('Published', 'Draft', 'In Progress', 'Archived')),
  github text not null default '',
  demo text not null default '',
  featured boolean not null default false,
  cover text not null default 'code',
  language text not null default '',
  readme text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.projects enable row level security;

-- Remove these named policies first so the script can safely be rerun.
drop policy if exists "Anyone can read published projects" on public.projects;
drop policy if exists "Authenticated admins can manage projects" on public.projects;

-- Visitors can read only published projects.
create policy "Anyone can read published projects"
  on public.projects
  for select
  to anon, authenticated
  using (status = 'Published' or auth.role() = 'authenticated');

-- Authenticated users can create, edit, and delete projects.
-- IMPORTANT: Disable public sign-ups in Supabase Auth settings and create only your admin user.
create policy "Authenticated admins can manage projects"
  on public.projects
  for all
  to authenticated
  using (true)
  with check (true);

create or replace function public.set_project_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_projects_updated_at on public.projects;
create trigger set_projects_updated_at
  before update on public.projects
  for each row execute function public.set_project_updated_at();

-- Allow the browser client to use the table through the Supabase Data API.
grant select, insert, update, delete on public.projects to authenticated;
grant select on public.projects to anon;

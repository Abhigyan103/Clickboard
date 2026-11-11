-- Políticas de segurança do bucket de documentos do ClickBoard (Sprint 2 / T3).
-- Leitura pública; inserir, atualizar e apagar SOMENTE para a coordenação (US-01).
-- Ajuste 'documents' para o nome real do bucket.
--
-- Como a coordenação é reconhecida no servidor:
--   o app envia o JWT do Firebase; a claim 'sub' é o uid do usuário. A tabela
--   public.admins guarda os uids da coordenação, e a função is_coordinator()
--   confere o 'sub' contra ela. Sem custom claims do Firebase, sem deploy extra.
--
-- Observação (Third-Party Auth com Firebase): o token do Firebase não traz o
-- papel 'authenticated' do Postgres, então as políticas de escrita são aplicadas
-- a 'public' e a decisão fica toda em is_coordinator().
--
-- ATENÇÃO ao aplicar: políticas permissivas do Postgres se SOMAM (OR). Se o
-- bucket ainda tiver alguma política antiga liberando escrita para 'anon' ou
-- para qualquer logado, ela continua valendo. Confira no painel
-- (Storage → Policies) e apague as antigas antes de aplicar este arquivo.

-- 1. Quem é coordenação -------------------------------------------------------

create table if not exists public.admins (
  uid  text primary key,          -- uid do Firebase Auth
  nome text
);

-- RLS ligado e nenhuma política: ninguém lê nem altera a tabela pela API.
-- A lista é mantida só pelo painel do Supabase.
alter table public.admins enable row level security;

-- security definer: roda com o dono da função, então enxerga public.admins
-- mesmo com o RLS fechado para quem chama.
create or replace function public.is_coordinator()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admins a where a.uid = auth.jwt() ->> 'sub'
  );
$$;

-- 2. Políticas do bucket -------------------------------------------------------

drop policy if exists "documents_public_read"        on storage.objects;
drop policy if exists "documents_signed_in_insert"   on storage.objects;
drop policy if exists "documents_signed_in_update"   on storage.objects;
drop policy if exists "documents_signed_in_delete"   on storage.objects;
drop policy if exists "documents_coordinator_insert" on storage.objects;
drop policy if exists "documents_coordinator_update" on storage.objects;
drop policy if exists "documents_coordinator_delete" on storage.objects;

create policy "documents_public_read"
  on storage.objects for select
  using (bucket_id = 'documents');

create policy "documents_coordinator_insert"
  on storage.objects for insert
  to public
  with check (bucket_id = 'documents' and public.is_coordinator());

create policy "documents_coordinator_update"
  on storage.objects for update
  to public
  using (bucket_id = 'documents' and public.is_coordinator());

create policy "documents_coordinator_delete"
  on storage.objects for delete
  to public
  using (bucket_id = 'documents' and public.is_coordinator());

-- 3. Cadastrar a coordenação (rodar no painel, com os uids reais) ---------------
-- insert into public.admins (uid, nome) values ('<UID_DO_FIREBASE>', '<NOME>');

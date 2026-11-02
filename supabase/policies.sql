-- Políticas de segurança do bucket de documentos do ClickBoard (Sprint 2 / T3).
-- Revogam a escrita anônima: a leitura é pública, mas inserir, atualizar e apagar
-- exigem um usuário autenticado. Ajuste 'documents' para o nome real do bucket.
--
-- Observação (Third-Party Auth com Firebase): o token do Firebase não traz o
-- papel 'authenticated' do Postgres, então as políticas de escrita são aplicadas
-- a 'public' e checam a presença de um JWT válido do Firebase (claim 'sub').
-- Sem token (anônimo) o 'sub' é nulo e a escrita é recusada; com login, passa.
-- Restringir só à coordenação exige uma claim 'isAdmin' no token (follow-up).

create policy "documents_public_read"
  on storage.objects for select
  using (bucket_id = 'documents');

create policy "documents_signed_in_insert"
  on storage.objects for insert
  to public
  with check (bucket_id = 'documents' and (auth.jwt() ->> 'sub') is not null);

create policy "documents_signed_in_update"
  on storage.objects for update
  to public
  using (bucket_id = 'documents' and (auth.jwt() ->> 'sub') is not null);

create policy "documents_signed_in_delete"
  on storage.objects for delete
  to public
  using (bucket_id = 'documents' and (auth.jwt() ->> 'sub') is not null);

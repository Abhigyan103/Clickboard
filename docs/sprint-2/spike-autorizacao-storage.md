# Spike - Autorização "de verdade" de avisos e documentos (US-01 / T3)

> Status: **proposta para ratificação** na sessão em dupla (Driver/Navigator) + PO.
> Sprint 2. Relacionado às issues **#4 (T3)** e **#1 (T0)**.

## Problema

O cliente pediu que a restrição de quem pode apagar/renomear/enviar avisos e
documentos valha **no servidor**, não só escondendo o botão na tela - *"pense em
quem tenta contornar a interface"*.

Hoje o conteúdo do ClickBoard está dividido em dois serviços:

1. **Metadados** (avisos e documentos) no **Cloud Firestore** - já protegidos por
   `firestore.rules` (só a coordenação escreve; `isAdmin` imutável). **Faltava o
   teste que comprova** → entregue em `firebase/rules-tests/rules.test.js`.
2. **Arquivos** (PDFs/imagens) no **Supabase Storage** - **vulnerável**:
   `lib/src/core/services/supabase_storage_service.dart:15-18` envia a
   **anon key** (embutida no app, em `supabase_config.dart`) no header
   `Authorization`. Quem extrai a chave do APK chama o Storage direto e
   **apaga/sobe arquivos sem passar por autorização alguma**. A UI não protege.

## Opções avaliadas

| Opção | Descrição | Prova no servidor | Custo | Esforço |
|---|---|---|---|---|
| **A. Supabase + Auth do Firebase (RLS)** | Mantém arquivos no Supabase; revoga escrita anônima no bucket e exige um JWT do Firebase; políticas RLS liberam só `authenticated`/coordenação | RLS do Supabase | Gratuito | Médio |
| B. Migrar arquivos p/ Firebase Storage + `storage.rules` | Unifica no Firebase; testável no mesmo emulador | `storage.rules` | **Pago (plano Blaze)** ❌ | Médio/alto |
| C. Edge Function no Supabase | Função server-side valida a autorização antes de gravar/apagar | Código da função | Gratuito | Alto |

## Decisão proposta: **Opção A**

**Por quê:** mantém a arquitetura gratuita atual (motivo original de o time ter
escolhido o Supabase em vez do Firebase Storage, que exige o plano pago Blaze) e
move a autorização para o servidor via RLS, eliminando a dependência da anon key
para escrita.

### O que entra (implementação - Opção A)

1. **Revogar escrita anônima** no bucket de documentos e aplicar as políticas
   versionadas em [`supabase/policies.sql`](../../supabase/policies.sql).
   *(passo de configuração no Supabase - feito por um humano)*
2. ~~**Autenticar as chamadas ao Storage** com o JWT do usuário em vez da anon
   key, no `SupabaseStorageService`.~~ **Feito** - o serviço passou a enviar o
   JWT do usuário autenticado (Firebase) no header `Authorization`, com fallback
   para a anon key quando não há sessão (que as políticas recusam).
3. ~~**Teste de aceite**~~ **Feito** - `test/features/documents/supabase_storage_service_test.dart`
   cobre: upload/delete enviam o JWT do usuário (não a anon key) e, quando o
   servidor recusa (403), a operação falha (a decisão é do servidor).

### Já entregue nesta tarefa (parte testável)

- Teste das `firestore.rules` no emulador (`firebase/rules-tests/`), cobrindo:
  aluno não escreve em `Documents`/`Notices`, coordenação escreve, `isAdmin`
  imutável, leitura exige autenticação.
- `SupabaseStorageService` autenticando pelo **JWT do usuário** + teste de
  unidade do comportamento (acima).
- Políticas do Supabase versionadas (`supabase/policies.sql`) - a aplicar no
  projeto durante a implementação.
- Configuração do emulador em `firebase.json`.

### Coordenação-apenas no Storage (decidido na revisão do PR #29)

A primeira versão das políticas liberava escrita para **qualquer usuário logado**
(`sub is not null`): um aluno, com o próprio token, ainda apagava arquivos da
coordenação chamando o Storage direto. Em vez de custom claims do Firebase (que
exigem Admin SDK e deploy de função), a coordenação passou a ser uma tabela no
próprio Supabase:

- `public.admins(uid)` com os uids do Firebase da coordenação, RLS ligado e
  nenhuma política (só editável pelo painel);
- `public.is_coordinator()` (`security definer`) confere o `sub` do JWT contra
  a tabela;
- as políticas de `insert`, `update` e `delete` do bucket exigem
  `is_coordinator()`.

### Falta (configuração no Supabase - passo humano)

- Ativar **Third-Party Auth (Firebase)** no painel do Supabase para validar o JWT.
- Em **Storage → Policies**, apagar políticas antigas que liberem escrita para
  `anon` ou para qualquer logado (políticas permissivas se somam).
- Rodar o `supabase/policies.sql` no SQL Editor.
- Cadastrar os uids da coordenação em `public.admins`.
- Gravar a evidência: aluno tentando apagar pelo Storage → recusado; coordenação
  apagando → sucesso.

## Critérios de aceite (status)

- [x] Aluno grava/apaga em `Documents`/`Notices` direto → **regra recusa**
      (coberto pelo teste das regras).
- [x] Aluno tenta mudar o próprio `isAdmin` → **recusado** (coberto).
- [x] Coordenação envia/renomeia/apaga pelo app → **funciona** (coberto).
- [~] Aluno chama o Storage direto para apagar → **servidor recusa**: políticas
      prontas em `supabase/policies.sql`; vale depois de aplicadas no painel.
      Evidência é manual (o teste do `SupabaseStorageService` usa resposta
      simulada e prova só o lado do cliente).

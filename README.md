<p align="center">
  <img src="assets/logo/logo.png" alt="ClickBoard" width="160">
</p>

<h1 align="center">ClickBoard</h1>

<p align="center">
  Aplicativo acadêmico em <strong>Flutter</strong> para alunos acompanharem
  <strong>avisos, notas e documentos</strong> da faculdade.
</p>

---

## 📌 Sobre o projeto

O **ClickBoard** é um aplicativo **Flutter** originalmente desenvolvido por
[Abhigyan103](https://github.com/Abhigyan103/Clickboard). Na disciplina de
**Análise, Projeto e Desenvolvimento Ágil**, a nossa equipe recebeu o projeto **pronto** (via *fork*)
para dar continuidade, aplicando práticas ágeis (Scrum + XP): backlog, user stories, Planning Poker,
MoSCoW e entregas incrementais por Sprint.

Este documento descreve **o que foi entregue**, **como o projeto está organizado** e **como executá-lo**.

---

## 👥 Equipe (Grupo 4)

Os papéis são **rotativos** entre as Sprints (prática de XP).

| Integrante | Papel na Sprint 1 | Papel na Sprint 2 |
|---|---|---|
| Nicolas Soares Oliveira | Product Owner (PO) | Desenvolvedor |
| João Vitor Cirico | Desenvolvedor | Product Owner (PO) |
| João Emanuel Silva Neri | Scrum Master (SM) | Desenvolvedor |
| Richard Machado dos Santos | Desenvolvedor | Scrum Master (SM) |

> O Matheus Modro Krueger saiu do time no Sprint 2.

---

## ✅ O que foi entregue na Sprint 1

A história da Sprint 1 (pedida pela professora, no papel de cliente) se desdobrou em duas user stories:

### HU01 - Só a coordenação altera conteúdo oficial
Antes, **qualquer** aluno logado podia renomear ou excluir avisos e documentos. Agora:
- cada usuário tem um **perfil** (aluno ou coordenação);
- **adicionar, renomear e excluir** documentos é permitido **apenas à coordenação** - na interface
  (os botões não aparecem para o aluno) **e** no servidor (regras de segurança do Firestore);
- as regras impedem, inclusive, que um usuário se promova a coordenação por conta própria.

### HU02 - Cadastro e acesso apenas com e-mail institucional
- o app aceita apenas e-mails **`@catolicasc.edu.br`** no cadastro, no login e na recuperação de senha
  (inclusive no acesso via Google), com mensagem clara quando o e-mail é de outro domínio;
- e-mails fora do padrão **não travam o app** nem geram departamento/matrícula incorretos.

> Como parte da continuidade, o armazenamento também foi ajustado para funcionar **sem custo** - ver
> a seção [Arquitetura](#-arquitetura).

---

## 🚀 Sprint 2 (N2)

> No Sprint 2 o time passou a trabalhar com TDD, refatoração com teste de regressão,
> revisão por Pull Request e integração contínua. Esta seção **incrementa** a N1.

### 🎯 Sprint Goal
Tornar a autorização de conteúdo oficial confiável **no servidor** (não só na interface) e
corrigir a edição de perfil, com cobertura de testes automatizados e CI.

### 📝 User Stories

#### US-01 - Autorização de avisos e documentos no servidor
**Como** coordenação, **quero** que apenas usuários autorizados consigam renomear, excluir ou
enviar avisos e documentos - inclusive por fora da interface -, **para** que o conteúdo oficial
não seja alterado por quem tenta contornar o aplicativo.

*INVEST:* independente da US-02; negociável (Firestore e Storage podem evoluir em etapas);
tem valor direto de segurança; estimável; pequena o suficiente para um Sprint; testável via
regras no emulador.

**Critérios de aceite:**
- **Dado** um aluno, **quando** ele chama o servidor direto para gravar/apagar em `Documents` ou
  `Notices`, **então** a regra recusa.
- **Dado** um aluno, **quando** tenta mudar o próprio `isAdmin`, **então** é recusado.
- **Dado** a coordenação, **quando** envia/renomeia/apaga pelo app, **então** funciona.
- **Dado** um aluno, **quando** chama o Storage direto para apagar um arquivo, **então** o servidor
  recusa e o arquivo permanece.

#### US-02 - Edição do nome no perfil
**Como** aluno, **quero** alterar meu nome no perfil e vê-lo salvo, **para** manter meus dados
corretos no aplicativo.

*INVEST:* independente; negociável; tem valor para o usuário; estimável; pequena; testável por
testes de unidade e de repositório.

**Critérios de aceite:**
- **Dado** um aluno, **quando** altera o nome e salva, **então** o nome é salvo e persiste após
  reabrir o app.
- **Dado** um nome vazio ou só com espaços, **quando** salva, **então** recebe erro em português e
  nada é gravado.
- **Dado** que a gravação falhou, **quando** salva, **então** recebe mensagem clara (sem sucesso
  falso nem erro silencioso).

### 📋 Backlog do Sprint 2

> Priorização (MoSCoW) e estimativa (Planning Poker) - ratificadas no Planning (issue #1).

| Item | Descrição | MoSCoW | Pts |
|---|---|---|---|
| T3 (US-01) | Autorização no servidor (regras + spike do storage) | Must | 13 |
| T4 (US-02) | Corrigir nome do perfil que não salva | Must | 5 |
| T1 | CI no GitHub Actions + primeiros testes | Must | 5 |
| T6 | Remover código herdado da JGEC (code smell) | Should | 3 |
| T2 | Injetar o storage no DocumentController (testabilidade) | Should | 3 |
| T5 | Tratamento de erro: catch vazio e BuildContext após await | Should | 3 |

**Pendências da N1 levadas ao Sprint 2:** a adaptação do `regValidate` (matrícula fora do padrão
da JGEC) estava em aberto e foi concluída junto da US-02.

### ✅ Definition of Done
Uma história está pronta quando: tem teste automatizado cobrindo o caminho principal; não
introduz code smell conhecido; foi revisada por um colega em Pull Request; está mergeada na
`main`; e a CI está verde (`flutter analyze` e `flutter test`).

### 🔎 Catálogo de code smells

| # | Onde | Smell | Refatoração aplicada | Teste de regressão | Tipo |
|---|---|---|---|---|---|
| 1 | `validators.dart` (`regValidate`) | Validação herdada da JGEC barrava matrícula "N/A", travando o `Form.validate()` e impedindo salvar o perfil | Aceitar matrícula vazia/"N/A"; padrão JGEC extraído para constante nomeada | `test/core/validators_test.dart` | Bug |
| 2 | `profile_repository.dart` (`editProfile`) | Gravava o documento inteiro, reenviando `isAdmin` como string e fazendo a regra do servidor recusar o update | Atualiza apenas os campos editáveis (nome e matrícula) | `test/features/profile/profile_repository_test.dart` | Bug |
| 3 | `student_model.dart` | Código morto: regex e derivações do padrão `@...jgec.ac.in`, nunca exercidas (o app só aceita `@catolicasc.edu.br`) | Remoção dos métodos mortos; `fromEmail` com valores neutros | `test/models/student_model_test.dart` | Refatoração |
| 4 | `supabase_storage_service.dart` + `supabase/policies.sql` | Anon key embutida no app autoriza escrita/exclusão direto no Storage | Chamadas ao Storage passam a enviar o **JWT do usuário** (não a anon key); políticas do bucket só liberam escrita para quem está em `public.admins` (coordenação), via `is_coordinator()` | `test/features/documents/supabase_storage_service_test.dart` (cliente) + evidência manual da recusa no servidor | Bug |
| 5 | `firestore.rules` (`Users` / `isCoordinator`) | Leitura direta de `resource.data.isAdmin`: em contas criadas antes da HU01 o campo não existe, a regra dá erro e recusa a edição do nome | `get('isAdmin', false)` nos dois lados da comparação e em `isCoordinator()` | `firebase/rules-tests/rules.test.js` (aluno antigo sem `isAdmin`) | Bug |

> **Limitação declarada (US-01, arquivos):** a restrição de escrita no Storage vale depois que
> `supabase/policies.sql` é aplicado no painel do Supabase, com o Third-Party Auth do Firebase
> ativo e os uids da coordenação cadastrados em `public.admins`. O teste automatizado do Storage
> prova o lado do cliente (envio do JWT e tratamento da recusa); a recusa pelo servidor é
> comprovada por evidência manual. Detalhes em `docs/sprint-2/spike-autorizacao-storage.md`.

### 🧪 Como rodar os testes

```sh
# Testes Dart (unidade e repositório)
flutter test

# Testes das regras do Firestore (precisa de Node e JDK/Java)
cd firebase/rules-tests && npm install && cd ../..
firebase emulators:exec --only firestore --project=demo-clickboard "npm --prefix firebase/rules-tests test"
```

> As regras rodam sobre um emulador em Java; no ambiente local sem Java, a execução ocorre na CI.

### 🔗 Links

- **Pipeline de CI (GitHub Actions):** <https://github.com/Nicolas-So06/Clickboard/actions/workflows/ci.yaml>
- **Pull Requests principais:** [#29 — Sprint 2 (N2)](https://github.com/Nicolas-So06/Clickboard/pull/29) (com revisão)
- **Vídeo de demonstração:** _<preencher: link não-listado>_

---

## 🛠️ Tecnologias

- **Flutter** `3.38.7` · **Dart** `3.10.7` (SDK Dart `>=3.0.5 <4.0.0`)
- **Firebase Authentication** - login (e-mail/senha e Google)
- **Cloud Firestore** - dados (perfis, metadados de avisos e documentos)
- **Supabase Storage** - arquivos (PDFs/imagens dos documentos)
- **Riverpod** - gerência de estado · **go_router** - navegação

> ⚠️ Use as versões acima do Flutter/Dart. Versões muito diferentes podem gerar erros de dependência
> e de API.

---

## 🧱 Arquitetura

O projeto segue **Clean Architecture** com **Riverpod**, separando cada funcionalidade em camadas:

```
lib/src/features/<feature>/
  ├── models/         # modelos de dados (ex.: Document, Notice, Student)
  ├── repository/     # acesso a dados (Firestore, Supabase)
  ├── controllers/    # regras de aplicação e estado (Riverpod)
  └── screens/        # interface (telas e widgets)
```

**Divisão de responsabilidades no backend (tudo em plano gratuito):**

| Precisa | Serviço | Por quê |
|---|---|---|
| Login | Firebase Authentication | e-mail/senha e Google |
| Dados (perfis, avisos, documentos) | Cloud Firestore | gratuito no plano Spark |
| Arquivos (PDF/imagem) | Supabase Storage | gratuito, sem cartão |

O **Firebase Storage** exige o plano pago **Blaze**; por isso os arquivos ficam no **Supabase** e os
metadados no **Firestore** (a URL pública do arquivo é guardada junto do documento). As regras de
segurança do Firestore estão versionadas em [`firestore.rules`](firestore.rules).

---

## ▶️ Como rodar

### 1. Pré-requisitos
- **Flutter `3.38.7`** instalado (`flutter --version` para conferir).
- Os **arquivos de configuração** (contêm chaves, por isso **não ficam no Git**):
  - `lib/firebase_options.dart` e `android/app/google-services.json` (Firebase)
  - `lib/supabase_config.dart` (Supabase - copie de `lib/supabase_config.example.dart` e preencha)
  - 🔑 Peça esses arquivos ao **PO** e cole nos caminhos acima. O time usa **um único** projeto
    Firebase e **um único** projeto Supabase - **não crie projetos próprios**.

### 2. Baixar dependências
```sh
git clone https://github.com/Nicolas-So06/Clickboard.git
cd Clickboard
flutter pub get      # o Flutter também regenera os arquivos de plugin automaticamente
flutter analyze      # deve terminar com 0 erros
```

### 3. Executar
```sh
flutter run            # Android: com um emulador aberto ou um celular (depuração USB)
flutter run -d chrome  # Web: para testar/demonstrar sem emulador
```

| Plataforma | Comportamento |
|---|---|
| **Android** (emulador ou celular) | Experiência completa (inclui notificações e câmera). |
| **Web** (Chrome) | Login, Firestore e documentos (upload/abrir/baixar). Notificações e câmera ficam desligadas - no `lib/main.dart` as notificações só são inicializadas fora da web (`if (!kIsWeb)`), o que **não afeta** o Android. |

<details>
<summary>Preparar a máquina para rodar no Android</summary>

- Instalar o **Android Studio** (traz o Android SDK) e criar um **emulador (AVD)**.
- Ligar o **Modo desenvolvedor** do Windows: `start ms-settings:developers`.
- Aceitar as licenças: `flutter doctor --android-licenses`.
- Validar com `flutter doctor` e rodar `flutter run`.
</details>

---

## 👤 Perfis de usuário (aluno × coordenação)

O perfil é definido pelo campo **`isAdmin`** no documento do usuário na coleção `Users` do Firestore:

- **Aluno** (`isAdmin` = `false`) - vê e baixa avisos/documentos, mas **não** adiciona, renomeia nem exclui.
- **Coordenação** (`isAdmin` = `true`) - gerencia o conteúdo oficial (adicionar, renomear, excluir).

**Para tornar um usuário coordenação:** Firebase Console → Firestore → coleção `Users` → documento do
usuário → definir **`isAdmin` = `true`** → no app, **sair e entrar de novo** para recarregar o perfil.

---

## 📄 Créditos e licença

- **Projeto original:** [Abhigyan103/Clickboard](https://github.com/Abhigyan103/Clickboard) - criado por Abhigyan Singh.
- Distribuído sob a licença **MIT** (ver [`LICENSE`](LICENSE)).
- Continuação acadêmica pela **Equipe 4** - disciplina de Análise, Projeto e Desenvolvimento Ágil.

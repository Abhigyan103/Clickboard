# Testes das regras do Firestore (Sprint 2 / T3)

Provam, no servidor, que apenas a coordenação escreve em `Documents`/`Notices` e
que `isAdmin` é imutável — exercitando as regras reais de `firestore.rules`.

## Pré-requisitos

- Node.js e `firebase-tools` (já no projeto).
- **JDK (Java)** — o emulador do Firestore exige Java. Ex. no Windows:
  `winget install EclipseAdoptium.Temurin.21.JDK` e reabra o terminal.

## Rodar

A partir da raiz do repositório:

```sh
cd firebase/rules-tests && npm install && cd ../..
firebase emulators:exec --only firestore --project=demo-clickboard "npm --prefix firebase/rules-tests test"
```

O `emulators:exec` sobe o emulador, roda os testes e o encerra. Resultado verde
confirma que as regras bloqueiam o aluno e liberam a coordenação.

const { test, before, after, beforeEach } = require('node:test');
const fs = require('node:fs');
const path = require('node:path');

const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  setDoc,
  getDoc,
  deleteDoc,
  updateDoc,
} = require('firebase/firestore');

const COORD_UID = 'coord-1';
const STUDENT_UID = 'aluno-1';

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: 'demo-clickboard',
    firestore: {
      rules: fs.readFileSync(
        path.resolve(__dirname, '../../firestore.rules'),
        'utf8',
      ),
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'Users', COORD_UID), {
      'Full Name': 'Coordenadora',
      isAdmin: true,
    });
    await setDoc(doc(db, 'Users', STUDENT_UID), {
      'Full Name': 'Aluno',
      isAdmin: false,
    });
    await setDoc(doc(db, 'Documents', 'doc-1'), { title: 'Edital' });
    await setDoc(doc(db, 'Notices', 'aviso-1'), { title: 'Aviso' });
  });
});

function studentDb() {
  return testEnv.authenticatedContext(STUDENT_UID).firestore();
}
function coordDb() {
  return testEnv.authenticatedContext(COORD_UID).firestore();
}

test('aluno autenticado consegue LER documentos oficiais', async () => {
  await assertSucceeds(getDoc(doc(studentDb(), 'Documents', 'doc-1')));
});

test('visitante NÃO autenticado não consegue ler documentos', async () => {
  const anon = testEnv.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(anon, 'Documents', 'doc-1')));
});

test('aluno NÃO consegue criar/renomear documento oficial', async () => {
  await assertFails(
    setDoc(doc(studentDb(), 'Documents', 'doc-2'), { title: 'Falso' }),
  );
});

test('aluno NÃO consegue excluir documento oficial', async () => {
  await assertFails(deleteDoc(doc(studentDb(), 'Documents', 'doc-1')));
});

test('aluno NÃO consegue escrever em avisos (Notices)', async () => {
  await assertFails(
    setDoc(doc(studentDb(), 'Notices', 'aviso-2'), { title: 'Falso' }),
  );
});

test('coordenação CONSEGUE criar documento oficial', async () => {
  await assertSucceeds(
    setDoc(doc(coordDb(), 'Documents', 'doc-3'), { title: 'Novo edital' }),
  );
});

test('coordenação CONSEGUE excluir aviso', async () => {
  await assertSucceeds(deleteDoc(doc(coordDb(), 'Notices', 'aviso-1')));
});

test('aluno NÃO consegue se promover a coordenação (isAdmin imutável)', async () => {
  await assertFails(
    updateDoc(doc(studentDb(), 'Users', STUDENT_UID), { isAdmin: true }),
  );
});

test('aluno CONSEGUE editar o próprio perfil mantendo isAdmin', async () => {
  await assertSucceeds(
    updateDoc(doc(studentDb(), 'Users', STUDENT_UID), {
      'Full Name': 'Aluno Editado',
    }),
  );
});

// US-02: contas criadas antes da HU01 não têm o campo isAdmin. Ler um campo
// inexistente nas regras gera erro, e o Firestore recusava o update do nome.
const LEGACY_UID = 'aluno-antigo';

async function seedLegacyStudent() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'Users', LEGACY_UID), {
      'Full Name': 'Aluno Antigo',
    });
  });
}

test('aluno antigo (sem isAdmin) CONSEGUE editar o próprio nome', async () => {
  await seedLegacyStudent();
  const db = testEnv.authenticatedContext(LEGACY_UID).firestore();

  await assertSucceeds(
    updateDoc(doc(db, 'Users', LEGACY_UID), { 'Full Name': 'Nome Novo' }),
  );
});

test('aluno antigo (sem isAdmin) NÃO consegue se promover a coordenação', async () => {
  await seedLegacyStudent();
  const db = testEnv.authenticatedContext(LEGACY_UID).firestore();

  await assertFails(updateDoc(doc(db, 'Users', LEGACY_UID), { isAdmin: true }));
});

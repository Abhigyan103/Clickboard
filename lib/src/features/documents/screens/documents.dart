import 'package:clickboard/src/features/documents/screens/widgets/document_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/common_widgets/fx/app_page.dart';
import '../../../core/common_widgets/fx/reveal_in.dart';
import '../../../core/common_widgets/sliver_message.dart';
import '../../../core/design/app_tokens.dart';
import '../../../models/document_model.dart';
import '../../../providers/utils_providers.dart';
import '../controllers/document_controller.dart';

/// Limite de documentos oficiais no mural.
const _maxDocuments = 5;

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({super.key});
  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  String searchString = '';

  Future<void> _addDocuments(int currentCount) async {
    final messenger = ScaffoldMessenger.of(context);
    if (currentCount >= _maxDocuments) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Limite de $_maxDocuments documentos atingido')));
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Enviando...'),
            ],
          ),
        ),
      ),
    );
    try {
      final result =
          await ref.read(documentControllerProvider.notifier).uploadFiles();
      result.fold(
        (error) => messenger.showSnackBar(SnackBar(content: Text(error))),
        (_) => messenger.showSnackBar(
            const SnackBar(content: Text('Documento(s) adicionado(s)'))),
      );
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var documentsFuture = ref.watch(documentFutureProvider());
    List<Document> documents = ref.watch(documentControllerProvider);
    // Só a coordenação adiciona documentos oficiais (HU01).
    final bool isCoordinator =
        ref.watch(myUserProvider)?.isCoordinator ?? false;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !isCoordinator
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 84),
              child: FloatingActionButton.extended(
                onPressed: () => _addDocuments(documents.length),
                tooltip: 'Adicionar documento',
                backgroundColor: AppTokens.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Adicionar',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(documentFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverContent(
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageHeader(
                        eyebrow: 'Biblioteca oficial',
                        title: 'Seus',
                        highlight: 'documentos',
                        subtitle: isCoordinator
                            ? 'Toque para abrir. Segure (ou use ⋮) para baixar, renomear ou excluir.'
                            : 'Toque para abrir. Segure (ou use ⋮) para baixar.',
                      ),
                      RevealIn(
                        delay: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: TextField(
                            onChanged: (value) =>
                                setState(() => searchString = value),
                            decoration: const InputDecoration(
                              hintText: 'Buscar pelo nome do documento',
                              prefixIcon: Icon(Icons.search_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverContent(
              sliver: documentsFuture.when(
                data: (data) {
                  documents = documents
                      .filter((t) => t.name
                          .toLowerCase()
                          .contains(searchString.toLowerCase()))
                      .toList();
                  if (documents.isEmpty) {
                    return SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.folder_open_rounded,
                        title: searchString.isEmpty
                            ? 'Nenhum documento ainda'
                            : 'Nada encontrado',
                        message: searchString.isEmpty
                            ? 'Os documentos publicados pela coordenação aparecem aqui.'
                            : 'Nenhum documento com "$searchString" no nome.',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    sliver: SliverGrid.builder(
                      itemCount: documents.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
                        mainAxisExtent: 210,
                      ),
                      itemBuilder: (context, index) => RevealIn(
                        delay: Duration(milliseconds: 60 * index.clamp(0, 8)),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: DocumentPage(document: documents[index]),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => const SliverMessage(
                    'Não foi possível carregar os documentos'),
                loading: () => const SliverToBoxAdapter(
                    child: SkeletonList(count: 3, height: 120)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

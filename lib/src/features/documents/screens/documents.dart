import 'package:clickboard/src/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/utils/utils.dart';
import '../../../models/document_model.dart';
import '../controllers/document_controller.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  DocumentScreen({super.key});
  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    var documentsFuture = ref.watch(documentFutureProvider());
    List<Document> documents = ref.watch(documentControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add a new document',
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(documentFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Documents',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SearchAnchor(
                        builder: (context, controller) {
                          return SearchBar(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 20)),
                            leading: Icon(
                              Icons.search,
                              color: AppColors.bg,
                            ),
                            onTap: () {},
                            onChanged: (value) {
                              setState(() {
                                searchString = value;
                              });
                            },
                            hintText: 'Document Name',
                            hintStyle: MaterialStatePropertyAll(
                                TextStyle(color: Colors.grey[500])),
                          );
                        },
                        suggestionsBuilder: (context, controller) => []),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            documentsFuture.when(
                data: (data) {
                  documents = documents
                      .filter((t) => t.name
                          .toLowerCase()
                          .contains(searchString.toLowerCase()))
                      .toList();
                  if (documents.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Center(child: Text('No Documents')));
                  }
                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      Color col = (index % 2 == 0)
                          ? const Color.fromARGB(57, 41, 41, 41)
                          : const Color.fromARGB(57, 65, 65, 65);
                      return ListTile(
                        tileColor: col,
                        title: Text(documents[index].name),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            var path = await ref
                                .read(documentControllerProvider.notifier)
                                .downloadDocument(documents[index]);
                            path.fold(
                                (l) => showSnackBar(
                                    context: context,
                                    title: l,
                                    snackBarType: SnackBarType.error), (r) {
                              showSnackBar(
                                  context: context,
                                  title: 'File saved in $r',
                                  snackBarType: SnackBarType.good);
                            });
                          },
                        ),
                        onTap: () => ref
                            .read(documentControllerProvider.notifier)
                            .openDocument(context, documents[index]),
                      );
                    },
                    itemCount: documents.length,
                  );
                },
                error: (error, stackTrace) {
                  return const Center(child: Text('Error'));
                },
                loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()))),
          ],
        ),
      ),
    );
  }
}

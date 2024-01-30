import 'package:clickboard/src/core/constants/colors.dart';
import 'package:clickboard/src/features/documents/screens/widgets/document_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/common_widgets/my_app_bar.dart';
import '../../../models/document_model.dart';
import '../controllers/document_controller.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({super.key});
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
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("Loading...",
                      style: TextStyle(color: Colors.black),),
                    ],
                  ),
                ),
              );
            },
          );
          try {
            await ref.read(documentControllerProvider.notifier).uploadFiles();
            Navigator.pop(context);

          } catch (e) {
            Navigator.pop(context);
          }

        },
        tooltip: 'Add a new document',
        child: const Icon(Icons.add),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SearchAnchor(
                        builder: (context, controller) {
                          return SearchBar(
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 20)),
                            leading: const Icon(
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
                  print(documents.length);
                  if (documents.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Center(child: Text('No Documents')));
                  }
                  return SliverGrid.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DocumentPage(
                          document: documents[index],
                        ),
                      );
                    },
                    itemCount: documents.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 0.9,
                        maxCrossAxisExtent:
                            MediaQuery.sizeOf(context).width - 50),
                  );
                },
                error: (error, stackTrace) {
                  return const Center(child: Text('Error'));
                },
                loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()))
            ),
          ],
        ),
      ),
    );
  }
}

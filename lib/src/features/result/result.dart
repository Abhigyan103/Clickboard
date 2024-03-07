import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../core/common_widgets/my_app_bar.dart';
import '../../core/utils/utils.dart';
import '../../models/result_model.dart';
import 'controllers/result_controller.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  openResult(Result result) async {
    var file = await ref
        .read(resultControllerProvider.notifier)
        .saveResultFile(result);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }

  @override
  Widget build(BuildContext context) {
    var resultsFuture = ref.watch(resultFutureProvider());
    List<Result> results = ref.watch(resultControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(resultFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Results',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            resultsFuture.when(
                data: (data) {
                  if (results.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Center(child: Text('No Results')));
                  }
                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      Color col = (index % 2 == 0)
                          ? const Color.fromARGB(57, 41, 41, 41)
                          : const Color.fromARGB(57, 65, 65, 65);
                      return ListTile(
                        tileColor: col,
                        title: Text(results[index].name),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            var path = await ref
                                .read(resultControllerProvider.notifier)
                                .downloadResult(results[index]);
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
                        onTap: () => openResult(results[index]),
                      );
                    },
                    itemCount: results.length,
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

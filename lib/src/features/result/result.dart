import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/features/result/controllers/result_controller.dart';
import 'package:jgec_notice/src/models/result_model.dart';

import '../../core/common_widgets/my_app_bar.dart';
import '../../core/utils/utils.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var resultsFuture = ref.watch(resultFutureProvider);
    List<Result> results = ref.watch(resultProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: RefreshIndicator(
        onRefresh: () => ref.watch(resultProvider.notifier).getAllResults(),
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
                                .read(resultProvider.notifier)
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
                        onTap: () => ref
                            .read(resultProvider.notifier)
                            .openResult(context, results[index]),
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

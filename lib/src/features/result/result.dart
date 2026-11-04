import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../core/common_widgets/fx/app_page.dart';
import '../../core/common_widgets/fx/hover_card.dart';
import '../../core/common_widgets/fx/reveal_in.dart';
import '../../core/common_widgets/sliver_message.dart';
import '../../core/design/app_tokens.dart';
import '../../core/utils/utils.dart';
import '../../models/result_model.dart';
import 'controllers/result_controller.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  Future<void> openResult(Result result) async {
    var file = await ref
        .read(resultControllerProvider.notifier)
        .saveResultFile(result);
    if (!mounted) return;
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }

  Future<void> downloadResult(Result result) async {
    var path =
        await ref.read(resultControllerProvider.notifier).downloadResult(result);
    if (!mounted) return;
    path.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) => showSnackBar(
            context: context,
            title: 'Arquivo salvo em $r',
            snackBarType: SnackBarType.good));
  }

  @override
  Widget build(BuildContext context) {
    var resultsFuture = ref.watch(resultFutureProvider());
    List<Result> results = ref.watch(resultControllerProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(resultFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          primary: true,
          slivers: [
            const SliverContent(
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: PageHeader(
                    eyebrow: 'Desempenho',
                    title: 'Suas',
                    highlight: 'notas',
                    subtitle: 'Boletins e resultados publicados para você.',
                  ),
                ),
              ),
            ),
            SliverContent(
              sliver: resultsFuture.when(
                data: (data) {
                  if (results.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.assignment_outlined,
                        title: 'Nenhuma nota publicada',
                        message:
                            'Quando um resultado sair, ele aparece aqui.',
                      ),
                    );
                  }
                  return SliverList.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) => RevealIn(
                      delay: Duration(milliseconds: 60 * index.clamp(0, 8)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: HoverCard(
                          onTap: () => openResult(results[index]),
                          child: Row(
                            children: [
                              const IconBubble(
                                  icon: Icons.assignment_rounded,
                                  color: Color(0xFF5EE0A0)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  results[index].name,
                                  style: const TextStyle(
                                      color: AppTokens.text,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Baixar',
                                icon: const Icon(Icons.download_rounded,
                                    color: AppTokens.textMuted),
                                onPressed: () =>
                                    downloadResult(results[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => const SliverMessage(
                    'Não foi possível carregar os resultados'),
                loading: () =>
                    const SliverToBoxAdapter(child: SkeletonList(count: 3)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

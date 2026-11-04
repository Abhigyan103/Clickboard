import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/fx/app_page.dart';
import '../../../core/common_widgets/fx/reveal_in.dart';
import '../../../core/common_widgets/sliver_message.dart';
import '../../../core/design/app_tokens.dart';
import '../../../models/notice_model.dart';
import '../../../providers/utils_providers.dart';
import '../controllers/carousel_controller.dart';
import '../controllers/notice_controller.dart';
import 'widgets/notice_tile.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var noticesFuture = ref.watch(noticeFutureProvider());
    var carouselFuture = ref.watch(carouselFutureProvider());
    List<Notice> notices = ref.read(noticeControllerProvider);
    List<Image> carouselImages = ref.read(carouselControllerProvider);
    final firstName =
        (ref.watch(myUserProvider)?.name ?? '').trim().split(' ').first;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(noticeFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          slivers: [
            SliverContent(
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: PageHeader(
                    eyebrow: 'Mural da coordenação',
                    title: firstName.isEmpty ? 'Olá!' : 'Olá,',
                    highlight: firstName.isEmpty ? null : firstName,
                    subtitle: 'Os avisos mais recentes da Católica SC.',
                  ),
                ),
              ),
            ),
            SliverContent(
              sliver: SliverToBoxAdapter(
                child: carouselFuture.maybeWhen(
                  data: (_) => carouselImages.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CarouselSlider.builder(
                            itemCount: carouselImages.length,
                            itemBuilder: (context, index, _) => Container(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppTokens.radiusLg),
                                border: Border.all(color: AppTokens.border),
                              ),
                              child: carouselImages[index],
                            ),
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              autoPlay: true,
                              autoPlayCurve: AppTokens.easeOut,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 900),
                            ),
                          ),
                        ),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
            SliverContent(
              sliver: noticesFuture.when(
                data: (data) {
                  if (notices.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.campaign_outlined,
                        title: 'Nenhum aviso por enquanto',
                        message:
                            'Quando a coordenação publicar algo, aparece aqui.',
                      ),
                    );
                  }
                  return SliverList.builder(
                    itemCount: notices.length,
                    itemBuilder: (context, index) => RevealIn(
                      delay: Duration(milliseconds: 60 * index.clamp(0, 8)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: NoticeTile(notice: notices[index]),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => const SliverMessage(
                    'Não foi possível carregar os avisos'),
                loading: () =>
                    const SliverToBoxAdapter(child: SkeletonList()),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

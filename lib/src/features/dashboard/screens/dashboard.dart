import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/my_app_bar.dart';
import '../../../models/notice_model.dart';
import '../controllers/carousel_controller.dart';
import '../controllers/notice_controller.dart';
import 'widgets/notice_tile.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  buildCarouselContainer({Widget? child}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(89, 56, 4, 0),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var noticesFuture = ref.watch(noticeFutureProvider());
    var carouselFuture = ref.watch(carouselFutureProvider());
    List<Notice> notices = ref.read(noticeControllerProvider);
    List<Image> carouselImages = ref.read(carouselControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(noticeFutureProvider(isRefreshed: true).future),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  carouselFuture.when(
                      data: (data) {
                        if (carouselImages.isNotEmpty) {
                          return CarouselSlider.builder(
                            itemBuilder: (context, index, realIndex) {
                              return buildCarouselContainer(
                                  child:
                                carouselImages[index]);
                            },
                            itemCount: carouselImages.length,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 2)),
                          );
                        }
                        return const SizedBox();
                      },
                      error: (error, stackTrace) {
                        return const SizedBox();
                      },
                      loading: () => const SizedBox()),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Notices',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            noticesFuture.when(
                data: (data) {
                  if (notices.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Center(child: Text('No Notices')));
                  }
                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      Color col = (index % 2 == 0)
                          ? const Color.fromARGB(57, 41, 41, 41)
                          : const Color.fromARGB(57, 65, 65, 65);
                      return NoticeTile(col: col, notice: notices[index]);
                    },
                    itemCount: notices.length,
                  );
                },
                error: (error, stackTrace) {
                  return const SliverToBoxAdapter(child: SizedBox());
                },
                loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()))),
          ],
        ),
      ),
    );
  }
}

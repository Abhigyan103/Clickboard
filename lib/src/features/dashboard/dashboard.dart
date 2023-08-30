import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jgec_notice/src/core/utils/utils.dart';
import 'package:jgec_notice/src/features/dashboard/controllers/carousel_controller.dart';
import 'package:jgec_notice/src/models/carousel_model.dart';

import '../../core/common_widgets/my_app_bar.dart';
import '../../models/notice_model.dart';
import 'controllers/notice_controller.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  buildCarouselContainer({Widget? child}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var noticesFuture = ref.watch(noticeFutureProvider);
    var carouselFuture = ref.watch(carouselFutureProvider);
    List<Notice> notices = ref.watch(noticeProvider);
    List<CarouselImage> carouselImages = ref.watch(carouselProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: RefreshIndicator(
        onRefresh: () => ref.watch(noticeProvider.notifier).getAllNotices(),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  carouselFuture.when(
                      data: (data) {
                        return CarouselSlider.builder(
                          itemBuilder: (context, index, realIndex) {
                            return buildCarouselContainer(
                                child: Image.network(
                              carouselImages[index].url,
                              fit: BoxFit.cover,
                            ));
                          },
                          itemCount: carouselImages.length,
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              autoPlay: true,
                              autoPlayAnimationDuration:
                                  const Duration(seconds: 2)),
                        );
                      },
                      error: (error, stackTrace) => const SizedBox(),
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
                      return ListTile(
                        tileColor: col,
                        title: Text(notices[index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            var path = await ref
                                .read(noticeProvider.notifier)
                                .downloadNotice(notices[index]);

                            path.fold(
                                (l) => showSnackBar(
                                    context: context,
                                    title: l,
                                    color: Colors.red), (r) {
                              showSnackBar(
                                  context: context, title: 'File saved in $r');
                            });
                          },
                        ),
                        subtitle: Text(
                            DateFormat.jm()
                                .add_yMMMd()
                                .format(notices[index].timeCreated!),
                            style: Theme.of(context).textTheme.bodyLarge),
                        onTap: () => ref
                            .read(noticeProvider.notifier)
                            .openNotice(context, notices[index]),
                      );
                    },
                    itemCount: notices.length,
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/common_widgets/my_app_bar.dart';
import '../../core/utils/utils.dart';
import '../../models/carousel_model.dart';
import '../../models/notice_model.dart';
import 'controllers/carousel_controller.dart';
import 'controllers/notice_controller.dart';

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
    var noticesFuture = ref.watch(noticeFutureProvider);
    var carouselFuture = ref.watch(carouselFutureProvider);
    List<Notice> notices = ref.watch(noticeControllerProvider);
    List<CarouselImage> carouselImages = ref.watch(carouselControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: RefreshIndicator(
        onRefresh: () => ref.watch(noticeFutureProvider.future),
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
                        }
                        return const SizedBox();
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
                          icon: const Icon(
                            Icons.download,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            var path = await ref
                                .read(noticeControllerProvider.notifier)
                                .downloadNotice(notices[index]);

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
                        subtitle: Text(
                            DateFormat.yMMMd().format(
                                notices[index].timeCreated ?? DateTime.now()),
                            style: Theme.of(context).textTheme.bodyLarge),
                        onTap: () => ref
                            .read(noticeControllerProvider.notifier)
                            .openNotice(context, notices[index]),
                      );
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

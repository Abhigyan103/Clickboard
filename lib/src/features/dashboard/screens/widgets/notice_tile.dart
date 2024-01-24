import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/utils.dart';
import '../../../../models/notice_model.dart';
import '../../controllers/notice_controller.dart';

class NoticeTile extends ConsumerWidget {
  const NoticeTile({
    super.key,
    required this.col,
    required this.notice,
  });

  final Color col;
  final Notice notice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      tileColor: col,
      title: Text(notice.name),
      trailing: IconButton(
        icon: const Icon(
          Icons.download,
          color: Colors.grey,
        ),
        onPressed: () async {
          var path = await ref
              .read(noticeControllerProvider.notifier)
              .downloadNotice(notice);
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
          DateFormat.yMMMd().format(notice.timeCreated ?? DateTime.now()),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: const Color.fromARGB(81, 13, 245, 226))),
      onTap: () => ref
          .read(noticeControllerProvider.notifier)
          .openNotice(context, notice),
    );
  }
}

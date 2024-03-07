import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/utils/utils.dart';
import '../../../../models/notice_model.dart';
import '../../controllers/notice_controller.dart';

class NoticeTile extends ConsumerStatefulWidget {
  const NoticeTile({
    super.key,
    required this.col,
    required this.notice,
  });

  final Color col;
  final Notice notice;

  @override
  ConsumerState<NoticeTile> createState() => _NoticeTileState();
}

class _NoticeTileState extends ConsumerState<NoticeTile> {
  openNotice() async {
    var file = await ref
        .read(noticeControllerProvider.notifier)
        .saveNoticeFile(widget.notice);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.col,
      title: Text(widget.notice.name),
      trailing: IconButton(
        icon: const Icon(
          Icons.download,
          color: Colors.grey,
        ),
        onPressed: () async {
          var path = await ref
              .read(noticeControllerProvider.notifier)
              .downloadNotice(widget.notice);
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
          DateFormat.yMMMd()
              .format(widget.notice.timeCreated ?? DateTime.now()),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey[700])),
      onTap: openNotice,
    );
  }
}

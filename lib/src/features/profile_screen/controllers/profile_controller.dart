import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../features/authentication/controllers/auth_controller.dart';
import '../../../providers/type_defs.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
import '../repositories/profile_repository.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return ProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
  );
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _userProfileRepository;
  final Ref _ref;
  ProfileController(
      {required ProfileRepository userProfileRepository, required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        super(false);

  FutureVoid updateUserData() async {
    try {
      _ref.read(userProvider.notifier).update((state) {
        return _ref.read(getUserDataProvider(state!.uid)) as Student?;
      });
    } catch (e) {
      return left("Couldn't update profile.");
    }
    return right(null);
  }
}

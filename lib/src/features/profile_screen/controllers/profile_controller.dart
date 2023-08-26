import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../features/authentication/controllers/auth_controller.dart';
import '../../../providers/storage_repository_provider.dart';
import '../../../providers/type_defs.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
import '../repositories/profile_repository.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository, //For porfile Pic
    ref: ref,
  );
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ProfileController(
      {required ProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
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

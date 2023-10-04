import 'package:sectec30/config/shared_provider/shared_providers.dart';
import 'package:sectec30/features/profile/data/api/profile_api.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:sectec30/features/profile/data/repository/profile_repository.dart';
import 'package:sectec30/utils/key_value_storage_service.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileApiProvider = Provider<ProfileApi>((ref) {
  return ProfileApi(ref.read(dioClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.read(profileApiProvider));
});

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, Registration>((ref) {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return ProfileNotifier(
      ref: ref, keyValueStorageService: keyValueStorageService);
});

class ProfileNotifier extends StateNotifier<Registration> {
  final Ref ref;
  final KeyValueStorageService keyValueStorageService;

  ProfileNotifier({required this.keyValueStorageService, required this.ref})
      : super(Registration()) {
    profile();
  }

  Future profile() async {
    final curp = await keyValueStorageService.getValue<String>('curp');
    //final curp = 'GAHJ071225HMSRRVA3';
    await ref.read(profileRepositoryProvider).profile(curp!).then((value) {
      state = value;
    });
  }
}

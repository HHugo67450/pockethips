import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_registry_group.dart';
import 'package:pocket_hips/repository/hips_repository.dart';

import '../../data/hips/hips_registry.dart';

class HipsRegistryNotifier extends AsyncNotifier<List<HipsRegistry>> {

  @override
  FutureOr<List<HipsRegistry>> build() async {
    ref.keepAlive();

    final hipsRepository = ref.watch(hipsRepositoryProvider);
    return hipsRepository.getHipsRegistries();
  }
}

final hipsRegistryProvider = AsyncNotifierProvider
  <HipsRegistryNotifier, List<HipsRegistry>>(HipsRegistryNotifier.new);

final hipsRegistryGroupsProvider =
  Provider<AsyncValue<List<HipsRegistryGroup>>>((ref) {
    final registriesAsync = ref.watch(hipsRegistryProvider);

    return registriesAsync.when(
      data: (registries) => AsyncValue.data(HipsRegistryGroup.fromRegistries(registries)),
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    );
  });
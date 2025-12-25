import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';

import '../../../repository/hips_repository.dart';
import 'hips_registry_notifier.dart';

class HipsTotalNotifier extends AsyncNotifier<int> {

  @override
  FutureOr<int> build() async {
    final hipsRepository = ref.watch(hipsRepositoryProvider);
    final selectedProviders = ref.watch(filtersProvider).selectedProviders;
    final hipsRegistryGroups = ref.watch(hipsRegistryGroupsProvider).value ?? [];

    if (selectedProviders.isEmpty) {
      return 0;
    }

    int totalHips = 0;
    final futures = <Future<int?>>[];

    for (final providerName in selectedProviders) {
      final group = hipsRegistryGroups.firstWhere(
        (group) => group.displayName == providerName,
      );
      for (final registry in group.hipsRegistries) {
        futures.add(hipsRepository.getHipsTotal(registry.url));
      }
    }

    final results = await Future.wait(futures);
    for (final result in results) {
      if (result != null) {
        totalHips += result;
      }
    }
    return totalHips;
  }
}

final hipsTotalProvider = AsyncNotifierProvider<HipsTotalNotifier, int>(
  HipsTotalNotifier.new,
);
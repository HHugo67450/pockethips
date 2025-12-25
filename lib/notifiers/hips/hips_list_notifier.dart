import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';
import 'package:pocket_hips/repository/hips_repository.dart';

import 'hips_registry_notifier.dart';

class HipsListNotifier extends AsyncNotifier<List<HipsDetail>> {
  @override
  FutureOr<List<HipsDetail>> build() async {
    ref.keepAlive();
    final hipsRepository = ref.watch(hipsRepositoryProvider);
    final selectedProviders = ref.watch(filtersProvider).selectedProviders;
    final hipsRegistryGroups = ref.watch(hipsRegistryGroupsProvider).value ?? [];

    if (selectedProviders.isEmpty) {
      return [];
    }

    final List<HipsDetail> hipsDetails = [];
    final futures = <Future<List<HipsDetail>>>[];

    for (final providerName in selectedProviders) {
      final group = hipsRegistryGroups.firstWhere(
        (group) => group.displayName == providerName,
      );
      for (final registry in group.hipsRegistries) {
        futures.add(hipsRepository.getHipsDetail(registry.url));
      }
    }

    final results = await Future.wait(futures);
    for (final resultList in results) {
      hipsDetails.addAll(resultList);
    }

    return hipsDetails;
  }
}

final hipsListProvider = AsyncNotifierProvider<HipsListNotifier, List<HipsDetail>>(HipsListNotifier.new);
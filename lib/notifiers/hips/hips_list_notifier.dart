import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';
import 'package:pocket_hips/repository/hips_repository.dart';

import '../filters/favorites_notifier.dart';
import 'hips_registry_notifier.dart';

class HipsListNotifier extends AsyncNotifier<List<HipsDetail>> {
  @override
  FutureOr<List<HipsDetail>> build() async {
    ref.keepAlive();
    final hipsRepository = ref.watch(hipsRepositoryProvider);

    final selectedProviders = ref.watch(filtersProvider
        .select((filtersState) => filtersState.selectedProviders));
    final selectedContentTypes = ref.watch(filtersProvider
        .select((filtersState) => filtersState.contentType));
    final selectedColors = ref.watch(filtersProvider
        .select((filtersState) => filtersState.colorSelected));
    final yearRange = ref.watch(filtersProvider
        .select((filtersState) => filtersState.yearRange));

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
        futures.add(hipsRepository.getHipsDetail(
          registry.url,
          providerName,
          selectedContentTypes,
          selectedColors,
          yearRange!,
        ));
      }
    }

    final results = await Future.wait(futures);
    for (final resultList in results) {
      hipsDetails.addAll(resultList);
    }

    return hipsDetails;
  }
}

final hipsListProvider = AsyncNotifierProvider
    <HipsListNotifier, List<HipsDetail>>(HipsListNotifier.new);

final filteredHipsListProvider = Provider<AsyncValue<List<HipsDetail>>>((ref) {
  final hipsAsync = ref.watch(hipsListProvider);
  final filters = ref.watch(filtersProvider);
  final favorites = ref.watch(favoritesProvider);

  return hipsAsync.when(
    data: (hipsDetails) {
      Iterable<HipsDetail> result = hipsDetails;

      if (filters.favoritesOnly) {
        result = result.where(
            (hipsDetail) => favorites.contains(hipsDetail.id),
        );
      }

      return AsyncValue.data(result.toList());
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
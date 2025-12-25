import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/filters.dart';
import '../hips/hips_registry_notifier.dart';

class FiltersNotifier extends Notifier<Filters> {
  bool _initialized = false;

  @override
  Filters build() {
    ref.listen(hipsRegistryGroupsProvider, (previous, next) {
      next.whenData((groups) {
        final providers = groups.map((group) => group.displayName).toList();
        initDefaultProvider(providers);
      });
    });
    return const Filters();
  }

  void initDefaultProvider(List<String> providers) {
    if (_initialized) {
      return;
    }

    if (providers.isEmpty) {
      return;
    }

    state = state.copyWith(
      selectedProviders: [providers.first],
    );

    _initialized = true;
  }

  void toggleFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }

  void toggleProvider(String provider) {
    final updated = List<String>.from(state.selectedProviders);

    if (updated.contains(provider)) {
      updated.remove(provider);
    } else {
      updated.add(provider);
    }

    state = state.copyWith(selectedProviders: updated);
  }
}

final filtersProvider = NotifierProvider<FiltersNotifier, Filters>(
    FiltersNotifier.new
);
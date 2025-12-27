import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/filters.dart';
import '../hips/hips_registry_notifier.dart';

class FiltersNotifier extends Notifier<Filters> {
  bool _initialized = false;

  final double minYear = 1950.0;
  final double maxYear = DateTime.now().year.toDouble();

  @override
  Filters build() {
    ref.listen(hipsRegistryGroupsProvider, (previous, next) {
      next.whenData((groups) {
        final providers = groups.map((group) => group.displayName).toList();
        initDefaultProvider(providers);
      });
    });
    return Filters(
      yearRange: RangeValues(minYear, maxYear),
    );
  }

  void initDefaultProvider(List<String> providers) {
    if (_initialized) {
      return;
    }

    if (providers.isEmpty) {
      return;
    }

    state = state.copyWith(selectedProviders: [providers.first]);

    _initialized = true;
  }

  void toggleFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }

  void toggleFavoritesOnly() {
    state = state.copyWith(favoritesOnly: !state.favoritesOnly);
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

  void toggleContentType(String contentType) {
    final updated = List<String>.from(state.contentType);
    final contentTypeLower = contentType.toLowerCase();

    if (updated.contains(contentTypeLower)) {
      updated.remove(contentTypeLower);
    } else {
      updated.add(contentTypeLower);
    }

    state = state.copyWith(contentType: updated);
  }


  void toggleColor(String color) {
    final updated = List<String>.from(state.colorSelected);
    final colorLower = color.toLowerCase();

    if (updated.contains(colorLower)) {
      updated.remove(colorLower);
    } else {
      updated.add(colorLower);
    }

    state = state.copyWith(colorSelected: updated);
  }

  void setYearRange(RangeValues yearRange) {
    state = state.copyWith(yearRange: yearRange);
  }

  void toggleSearch() {
    state = state.copyWith(isSearching: !state.isSearching);
  }

  void setSearchQuery(String searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
  }
  
  void resetFilters() {
    state = Filters(
      yearRange: RangeValues(minYear, maxYear),
      selectedProviders: [],
      contentType: [],
      colorSelected: [],
      favoritesOnly: false,
      searchQuery: "",
    );
  }
}

final filtersProvider = NotifierProvider<FiltersNotifier, Filters>(
    FiltersNotifier.new
);
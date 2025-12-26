class Filters {
  final bool showFilters;
  final bool favoritesOnly;
  final List<String> selectedProviders;

  const Filters({
    this.showFilters = true,
    this.favoritesOnly = false,
    this.selectedProviders = const [],
  });

  Filters copyWith({
    bool? showFilters,
    bool? favoritesOnly,
    List<String>? selectedProviders,
  }) {
    return Filters(
      showFilters: showFilters ?? this.showFilters,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      selectedProviders: selectedProviders ?? this.selectedProviders,
    );
  }
}
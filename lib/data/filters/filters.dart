class Filters {
  final bool showFilters;
  final bool favoritesOnly;
  final List<String> selectedProviders;
  final List<String> contentType;

  const Filters({
    this.showFilters = true,
    this.favoritesOnly = false,
    this.selectedProviders = const [],
    this.contentType = const ['Image', 'Catalog', 'Cube']
  });

  Filters copyWith({
    bool? showFilters,
    bool? favoritesOnly,
    List<String>? selectedProviders,
    List<String>? contentType,
  }) {
    return Filters(
      showFilters: showFilters ?? this.showFilters,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      contentType: contentType ?? this.contentType,
    );
  }
}
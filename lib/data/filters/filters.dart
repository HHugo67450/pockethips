class Filters {
  final bool showFilters;
  final bool favoritesOnly;
  final List<String> selectedProviders;
  final List<String> contentType;
  final List<String> colorSelected;

  const Filters({
    this.showFilters = true,
    this.favoritesOnly = false,
    this.selectedProviders = const [],
    this.contentType = const [],
    this.colorSelected = const [],
  });

  Filters copyWith({
    bool? showFilters,
    bool? favoritesOnly,
    List<String>? selectedProviders,
    List<String>? contentType,
    List<String>? colorSelected,
  }) {
    return Filters(
      showFilters: showFilters ?? this.showFilters,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      contentType: contentType ?? this.contentType,
      colorSelected: colorSelected ?? this.colorSelected,
    );
  }
}
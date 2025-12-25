class Filters {
  final bool showFilters;
  final List<String> selectedProviders;

  const Filters({
    this.showFilters = true,
    this.selectedProviders = const [],
  });

  Filters copyWith({
    bool? showFilters,
    List<String>? selectedProviders,
  }) {
    return Filters(
      showFilters: showFilters ?? this.showFilters,
      selectedProviders: selectedProviders ?? this.selectedProviders,
    );
  }
}
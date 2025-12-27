import 'package:flutter/material.dart';

class Filters {
  final bool showFilters;
  final bool favoritesOnly;
  final List<String> selectedProviders;
  final List<String> contentType;
  final List<String> colorSelected;
  final RangeValues? yearRange;
  final bool isSearching;
  final String searchQuery;

  const Filters({
    this.showFilters = true,
    this.favoritesOnly = false,
    this.selectedProviders = const [],
    this.contentType = const [],
    this.colorSelected = const [],
    this.yearRange,
    this.isSearching = false,
    this.searchQuery = "",
  });

  Filters copyWith({
    bool? showFilters,
    bool? favoritesOnly,
    List<String>? selectedProviders,
    List<String>? contentType,
    List<String>? colorSelected,
    RangeValues? yearRange,
    bool? isSearching,
    String? searchQuery,
  }) {
    return Filters(
      showFilters: showFilters ?? this.showFilters,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      contentType: contentType ?? this.contentType,
      colorSelected: colorSelected ?? this.colorSelected,
      yearRange: yearRange ?? this.yearRange,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
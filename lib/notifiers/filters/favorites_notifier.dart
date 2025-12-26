import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/hips/hips_detail.dart';

class FavoritesNotifier extends Notifier<List<String>> {
  static const _storageKey = 'favorites_hips_id';

  @override
  List<String> build() {
    loadFavorites();
    return [];
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList(_storageKey) ?? [];
    state = storedFavorites;
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state);
  }

  Future<void> toggleFavorite(HipsDetail hipsDetail) async {
    final newState = List<String>.from(state);
    if (newState.contains(hipsDetail.id)) {
      newState.remove(hipsDetail.id);
    } else {
      newState.add(hipsDetail.id);
    }

    state = newState;
    debugPrint('Favorites: $state');
    await saveFavorites();
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(
  FavoritesNotifier.new,
);
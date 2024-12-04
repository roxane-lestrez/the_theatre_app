import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/show.dart';

final favoriteShowsProvider =
    StateNotifierProvider<FavoriteShowsNotifier, List<Show>>((ref) {
  return FavoriteShowsNotifier();
});

class FavoriteShowsNotifier extends StateNotifier<List<Show>> {
  FavoriteShowsNotifier() : super([]) {
    _loadFavorites();
  }

  void addShow(Show show) {
    state = [...state, show];
    _saveFavorites();
  }

  void removeShow(Show show) {
    state = state.where((s) => s.id != show.id).toList();
    _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        jsonEncode(state.map((show) => show.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List decoded = jsonDecode(favoritesJson);
      state = decoded.map((json) => Show.fromJson(json)).toList();
    }
  }
}

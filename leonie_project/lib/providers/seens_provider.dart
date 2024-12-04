import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/show.dart';

final seenShowsProvider =
    StateNotifierProvider<SeenShowsNotifier, List<Show>>((ref) {
  return SeenShowsNotifier();
});

class SeenShowsNotifier extends StateNotifier<List<Show>> {
  SeenShowsNotifier() : super([]) {
    _loadSeenShows();
  }

  void addShow(Show show) {
    state = [...state, show];
    _saveSeenShows();
  }

  void removeShow(Show show) {
    state = state.where((s) => s.id != show.id).toList();
    _saveSeenShows();
  }

  Future<void> _saveSeenShows() async {
    final prefs = await SharedPreferences.getInstance();
    final seenJson = jsonEncode(state.map((show) => show.toJson()).toList());
    await prefs.setString('seen', seenJson);
  }

  Future<void> _loadSeenShows() async {
    final prefs = await SharedPreferences.getInstance();
    final seenJson = prefs.getString('seen');
    if (seenJson != null) {
      final List decoded = jsonDecode(seenJson);
      state = decoded.map((json) => Show.fromJson(json)).toList();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/providers/favorites_provider.dart';
import 'package:first_app/providers/seens_provider.dart';
import 'package:first_app/widgets/show_list_selection.dart'; // Import the reusable widget

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteShows = ref.watch(favoriteShowsProvider);
    final seenShows = ref.watch(seenShowsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Pseudo
              const Center(
                child: Text(
                  'Pseudo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // "Seen" part
              ShowListSection(
                title: 'Seen',
                shows: seenShows,
              ),

              // "Wishlist" part
              ShowListSection(
                title: 'Wishlist',
                shows: favoriteShows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

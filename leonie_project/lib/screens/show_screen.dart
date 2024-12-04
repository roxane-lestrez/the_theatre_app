// AssetImage('assets/${show.id}.png')

import 'package:first_app/models/show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/providers/favorites_provider.dart';
import 'package:first_app/providers/seens_provider.dart';

class ShowScreen extends ConsumerWidget {
  const ShowScreen({super.key, required this.show});

  final Show show;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteShows = ref.watch(favoriteShowsProvider);
    final isFavorite = favoriteShows.any((favShow) => favShow.id == show.id);

    final seenShows = ref.watch(seenShowsProvider);
    final isSeen = seenShows.any((seenShow) => seenShow.id == show.id);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          show.title,
          style: const TextStyle(fontSize: 20),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200, // Set the height for the poster
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/${show.id}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Synopsis',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          show.synopsis,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 9, // Set maximum number of lines
                          overflow:
                              TextOverflow.ellipsis, // Add ellipsis if overflow
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(255, 231, 81, 141),
                    ),
                    iconSize: 35,
                    onPressed: () {
                      final notifier = ref.read(favoriteShowsProvider.notifier);
                      if (isFavorite) {
                        notifier.removeShow(show);
                      } else {
                        notifier.addShow(show);
                      }
                    },
                  ),
                  const Text(
                    'Add to Wishlist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isSeen
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded,
                      color: Colors.green,
                    ),
                    iconSize: 35,
                    onPressed: () {
                      final notifier = ref.read(seenShowsProvider.notifier);
                      if (isSeen) {
                        notifier.removeShow(show);
                      } else {
                        notifier.addShow(show);
                      }
                    },
                  ),
                  const Text(
                    'Add to Seenlist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '${show.productions.length} Productions worldwide',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...show.productions.map((production) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            production,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

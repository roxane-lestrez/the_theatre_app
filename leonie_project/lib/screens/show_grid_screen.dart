import 'package:flutter/material.dart';
import 'package:first_app/models/show.dart';
import 'package:first_app/screens/show_screen.dart';

class ShowGridScreen extends StatelessWidget {
  final String title;
  final List<Show> shows;

  const ShowGridScreen({
    super.key,
    required this.title,
    required this.shows,
  });

  void navigateToShowScreen(BuildContext context, Show show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowScreen(show: show),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          childAspectRatio: 2 / 3, // Aspect ratio for each grid item
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: shows.length,
        itemBuilder: (context, index) {
          final show = shows[index];
          return GestureDetector(
            onTap: () => navigateToShowScreen(context, show),
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  show.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/${show.id}.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

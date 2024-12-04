import 'package:first_app/pages/show_grid_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/show_page.dart';

// This widget creates a horizontally scrollable list with a button to open the list in a larger format on another page.

class ShowListSection extends StatelessWidget {
  final String title;
  final List<dynamic> shows;

  const ShowListSection({
    super.key,
    required this.title,
    required this.shows,
  });

  void navigateToShowPage(BuildContext context, Map show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPage(idShow: show['id_show']),
      ),
    );
  }

  void navigateToShowGrid(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowGridPage(
          title: title,
          shows: shows,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              // Title.
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Button to open the list in a larger format on another page.
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => navigateToShowGrid(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Scrollable list of shows.
          SizedBox(
            height: 210,
            child: shows.isEmpty
                ? const Center(
                    child: Text(
                      'This list is empty.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shows.length,
                    itemBuilder: (context, index) {
                      final show = shows[shows.length - index - 1];
                      return GestureDetector(
                        onTap: () => navigateToShowPage(context, show),
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Image of the show.
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors
                                      .grey, // Fallback color if image fails to load
                                  image: DecorationImage(
                                    image: NetworkImage(show['url_poster'] ??
                                        'https://static.wikia.nocookie.net/the-theatre/images/5/58/Noposter.jpeg/revision/latest?cb=20240818094701'), // Chargez l'image depuis l'URL
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Show title below the image.
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  show['title_show'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:first_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/show_page.dart';
import 'package:first_app/main.dart';

class ShowGridPage extends StatefulWidget {
  final String title;
  final List<dynamic> shows;

  const ShowGridPage({
    super.key,
    required this.title,
    required this.shows,
  });

  @override
  ShowGridPageState createState() => ShowGridPageState();
}

class ShowGridPageState extends State<ShowGridPage> with RouteAware {
  List<dynamic> updatedShows = [];

  @override
  void initState() {
    super.initState();
    updatedShows = widget.shows;
  }

  Future<void> _updateShows() async {
    List<dynamic>? fetchedShows = await fetchShows();
    if (fetchedShows != null) {
      setState(() {
        updatedShows =
            fetchedShows.where((show) => show['liked'] == true).toList();
      });
    }
  }

  // With this method, when the list of shows to be displayed on this page changes, the page is updated.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _updateShows();
  }

  void navigateToShowPage(BuildContext context, Map show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPage(idShow: show['id_show']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          childAspectRatio: 2 / 3, // Aspect ratio for each grid item
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: updatedShows.length,
        itemBuilder: (context, index) {
          final show = updatedShows[index];
          return GestureDetector(
            onTap: () => navigateToShowPage(context, show),
            child: GridTile(
              footer: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: GridTileBar(
                  backgroundColor: const Color.fromARGB(133, 0, 0, 0),
                  title: Text(
                    show['title_show'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(show['url_poster'] ??
                        'https://static.wikia.nocookie.net/the-theatre/images/5/58/Noposter.jpeg/revision/latest?cb=20240818094701'), // Chargez l'image depuis l'URL
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

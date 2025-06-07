import 'package:first_app/api_service.dart';
import 'package:first_app/pages/production_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/show_page.dart';
import 'package:first_app/main.dart';

class GridPage extends StatefulWidget {
  final String title;
  final List<dynamic> element;
  final String type;

  const GridPage({
    super.key,
    required this.title,
    required this.element,
    required this.type,
  });

  @override
  GridPageState createState() => GridPageState();
}

class GridPageState extends State<GridPage> with RouteAware {
  List<dynamic> updatedElements = [];

  @override
  void initState() {
    super.initState();
    updatedElements = widget.element;
  }

  Future<void> _updateFavoriteShows() async {
    final response = await callApiGet("shows");
    if (response != null) {
      setState(() {
        updatedElements =
            response.where((show) => show['liked'] == true).toList();
      });
    }
  }

  Future<void> _updateFavoriteProductions() async {
    final response = await callApiGet("productions");
    if (response != null) {
      setState(() {
        updatedElements =
            response.where((prod) => prod['liked'] == true).toList();
      });
    }
  }

  Future<void> _updateSeenProductions() async {
    final response = await callApiGet("productions");
    if (response != null) {
      setState(() {
        updatedElements =
            response.where((prod) => prod['seen'] == true).toList();
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
    switch (widget.type) {
      case 'show':
        _updateFavoriteShows();
        break;
      case 'favorite production':
        _updateFavoriteProductions();
        break;
      case 'seen production':
        _updateSeenProductions();
        break;
    }
  }

  void navigateToShowPage(BuildContext context, Map show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPage(idShow: show['id_show']),
      ),
    );
  }

  void navigateToProductionPage(BuildContext context, production) async {
    final show = await callApiGet("shows/${production['id_show']}/details");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductionPage(
          idProduction: production['id_production'],
          show: show,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: updatedElements.isEmpty
          ? Center(
              child: Text(
                'This list is empty.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 2 / 3, // Aspect ratio for each grid item
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: updatedElements.length,
              itemBuilder: (context, index) {
                final element = updatedElements[index];
                return GestureDetector(
                  onTap: () => widget.type == 'show'
                      ? navigateToShowPage(context, element)
                      : navigateToProductionPage(context, element),
                  child: GridTile(
                    footer: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: GridTileBar(
                        backgroundColor: const Color.fromARGB(133, 0, 0, 0),
                        title: Text(
                          widget.type == 'show'
                              ? element['title_show']
                              : element['name_production'],
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
                          image: NetworkImage(element['url_poster'] ??
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

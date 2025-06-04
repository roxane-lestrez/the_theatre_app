import 'package:first_app/api_service.dart';
import 'package:first_app/pages/production_page.dart';
import 'package:first_app/widgets/add_to_list_button.dart';
import 'package:first_app/widgets/poster_show.dart';
import 'package:first_app/widgets/productions_container.dart';
import 'package:first_app/widgets/synopsis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowPage extends ConsumerStatefulWidget {
  const ShowPage({super.key, required this.idShow});

  final int idShow;

  @override
  ShowPageState createState() => ShowPageState();
}

class ShowPageState extends ConsumerState<ShowPage> {
  Map show = {};
  List productions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    loadShow();
    loadProductions();
  }

  Future<void> loadShow() async {
    try {
      final response = await callApiGet("shows/${widget.idShow}/details");
      if (response != null) {
        setState(() {
          show = response;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> loadProductions() async {
    try {
      final response =
          await callApiGet("shows/${widget.idShow}/productionsfull");
      if (response != null) {
        setState(() {
          productions = response;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> tapHeart() async {
    if (show['liked'] == false) {
      await likeShow(widget.idShow);
    } else {
      await unlikeShow(widget.idShow);
    }
    loadShow();
  }

  void navigateToProductionPage(BuildContext context, production) {
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
    // Classify categories by group.
    final groupedProductions = <int, List<Map<String, dynamic>>>{};
    final correspondanceCategories = <int, String>{};
    for (var production in productions) {
      groupedProductions
          .putIfAbsent(production['id_cat'], () => [])
          .add(production);
      correspondanceCategories.putIfAbsent(
          production['id_cat'], () => production['title_cat']);
    }
    final sortedCategories = groupedProductions.keys.toList()..sort();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _isLoading
            ? const Text('Loading...')
            : Text(
                show['title_show'] ?? 'Show Title',
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text('Erreur lors du chargement des informations'))
              // Start of page content.
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image of the poster.
                            PosterShow(
                                imageUrl: show['url_poster'] ??
                                    'https://static.wikia.nocookie.net/the-theatre/images/5/58/Noposter.jpeg/revision/latest?cb=20240818094701'),
                            const SizedBox(width: 16),
                            // Synopsis.
                            Synopsis(
                                synopsisContent: show['synopsis_show'] ??
                                    'No synopsis available'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Wishlist button.
                        AddToListButton(
                            text: "Add to Wishlist",
                            iconButton: Icon(
                              show['liked']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color.fromARGB(255, 231, 81, 141),
                            ),
                            actionFunction: tapHeart),
                        const SizedBox(height: 30),
                        // Productions part.
                        // Title.
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${productions.length} Productions worldwide',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Content.
                        ProductionsContainer(
                            sortedCategories: sortedCategories,
                            groupedProductions: groupedProductions,
                            correspondanceCategories: correspondanceCategories,
                            navigateToProductionPageFunction:
                                navigateToProductionPage),
                      ],
                    ),
                  ),
                ),
    );
  }
}

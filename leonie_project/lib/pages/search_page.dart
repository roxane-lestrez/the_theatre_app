import 'package:first_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diacritic/diacritic.dart';

import 'show_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> availableShows = []; // Liste de tous les shows
  List<dynamic> _filteredShows = []; // Liste filtrée pour la recherche
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAndSetShows();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Vérifiez si availableShows est vide et recharger les données si nécessaire
  //   _fetchAndSetShows();
  // }

  Future<void> _fetchAndSetShows() async {
    setState(() {
      _isLoading = true; // Démarrez le chargement
      _hasError = false; // Réinitialisez l'état d'erreur
    });

    try {
      List<dynamic>? fetchedShows = await fetchShows();
      if (fetchedShows != null) {
        setState(() {
          availableShows =
              fetchedShows; // Mettez à jour la liste des shows disponibles
          _filteredShows = availableShows; // Mettez à jour la liste filtrée
          _isLoading = false; // Fin du chargement
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError =
              true; // Indiquez une erreur si aucun show n'a été récupéré
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true; // Indiquez une erreur en cas d'exception
      });
    }
  }

  // Filtrer les shows en fonction de la recherche
  void _filterData(String query) {
    final normalizedQuery = removeDiacritics(query.toLowerCase());
    setState(() {
      _filteredShows = availableShows.where((show) {
        return removeDiacritics(show['title_show'].toLowerCase())
            .contains(normalizedQuery);
      }).toList();
    });
  }

  // Sélectionner un show
  void selectShow(BuildContext context, Map show) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPage(
          idShow: show['id_show'],
        ),
      ),
    );
  }

  // Réinitialiser la recherche
  void resetSearch() {
    setState(() {
      _searchController.clear();
      _filteredShows = availableShows; // Réinitialisez la liste filtrée
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterData, // Filtrer lors de la saisie
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                ),
              ),
            ),
          ),
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? const Center(
                        child: Text('Erreur lors du chargement des shows'))
                    : _filteredShows.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _filteredShows.length,
                            itemBuilder: (context, index) {
                              final show = _filteredShows[index];
                              return InkWell(
                                onTap: () {
                                  selectShow(context, show);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      // Image of the show
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(show[
                                                    'url_poster'] ??
                                                'https://static.wikia.nocookie.net/the-theatre/images/5/58/Noposter.jpeg/revision/latest?cb=20240818094701'), // Chargez l'image depuis l'URL
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Show title
                                      Expanded(
                                        child: Text(
                                          show['title_show'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
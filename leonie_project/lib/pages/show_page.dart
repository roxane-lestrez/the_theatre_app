import 'package:first_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/pages/synopsis_page.dart';

class ShowPage extends ConsumerStatefulWidget {
  const ShowPage({super.key, required this.idShow});

  final int idShow;

  @override
  ShowPageState createState() => ShowPageState();
}

class ShowPageState extends ConsumerState<ShowPage> {
  Map show = {}; // Déclaration de la variable show
  List productions = [];
  bool _isLoading = true; // État de chargement
  bool _hasError = false; // État d'erreur

  @override
  void initState() {
    super.initState();
    _fetchShowInfo(); // Appel de la méthode pour récupérer les données
    _fetchProductionsInfo();
  }

  Future<void> _fetchShowInfo() async {
    try {
      final response =
          await getInfoShow(widget.idShow); // Remplacez par votre méthode d'API
      if (response != null) {
        setState(() {
          show = response; // Assurez-vous que 'response' est une Map
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

  Future<void> _fetchProductionsInfo() async {
    try {
      final response = await getInfoProductions(
          widget.idShow); // Remplacez par votre méthode d'API
      if (response != null) {
        setState(() {
          productions = response; // Assurez-vous que 'response' est une Map
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
    setState(() {
      if (show['liked'] == false) {
        likeShow(widget.idShow);
      } else {
        unlikeShow(widget.idShow);
      }
    });
    _fetchShowInfo();
  }

  @override
  Widget build(BuildContext context) {
    final groupedProductions = <int, List<Map<String, dynamic>>>{};
    for (var production in productions) {
      groupedProductions
          .putIfAbsent(production['id_cat'], () => [])
          .add(production);
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
                            Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                show['url_poster'] ??
                                    'https://static.wikia.nocookie.net/the-theatre/images/5/58/Noposter.jpeg/revision/latest?cb=20240818094701',
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SynopsisPage(
                                            synopsis: show['synopsis_show'] ??
                                                'No synopsis available',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      show['synopsis_show'] ??
                                          'No synopsis available',
                                      style: const TextStyle(fontSize: 16),
                                      maxLines: 9,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                show['liked']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color.fromARGB(255, 231, 81, 141),
                              ),
                              iconSize: 35,
                              onPressed: () => tapHeart(),
                            ),
                            const Text(
                              'Add to Wishlist',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(
                        //         isSeen
                        //             ? Icons.check_circle_rounded
                        //             : Icons.check_circle_outline_rounded,
                        //         color: Colors.green,
                        //       ),
                        //       iconSize: 35,
                        //       onPressed: () {
                        //         // Logique pour ajouter ou retirer des vues
                        //       },
                        //     ),
                        //     const Text(
                        //       'Add to Seenlist',
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.bold),
                        //     )
                        //   ],
                        // ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${productions.length} Productions worldwide',
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
                            children: sortedCategories.map((idCat) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      'Category $idCat',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...groupedProductions[idCat]!
                                      .map((production) {
                                    return InkWell(
                                      onTap: () {
                                        // Ajoutez ici une action pour les clics sur une production
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 246, 246),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          production['name_production'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}

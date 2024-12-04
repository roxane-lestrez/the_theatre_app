import 'package:first_app/Data/shows_data.dart';
import 'package:first_app/models/show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diacritic/diacritic.dart';

import 'show_screen.dart';

// This file manages the search screen.

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Show> availableShows = shows;
  List<Show> _filteredShows = shows;

  void _filterData(String query) {
    final normalizedQuery = removeDiacritics(query.toLowerCase());
    setState(() {
      _filteredShows = availableShows.where((show) {
        return removeDiacritics(show.title.toLowerCase())
            .contains(normalizedQuery);
      }).toList();
    });
  }

  void selectShow(BuildContext context, Show show) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowScreen(
          show: show,
        ),
      ),
    );
  }

  void resetSearch() {
    setState(() {
      _searchController.clear();
      _filteredShows = availableShows;
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
                // Box of search
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
                // Logo and text in the box
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterData,
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
            child: _filteredShows.isEmpty
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
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/${show.id}.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Show title
                              Expanded(
                                child: Text(
                                  show.title,
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

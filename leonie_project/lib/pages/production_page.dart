import 'package:first_app/api_service.dart';
import 'package:first_app/pages/show_page.dart';
import 'package:first_app/utils/constants.dart';
import 'package:first_app/widgets/action_choosing_tap_check_location.dart';
import 'package:first_app/widgets/add_to_list_button.dart';
import 'package:first_app/widgets/location_chooser.dart';
import 'package:first_app/widgets/locations_container.dart';
import 'package:first_app/widgets/poster_production.dart';
import 'package:first_app/widgets/seen_chooser_location.dart';
import 'package:first_app/widgets/seen_chooser_production.dart';
import 'package:flutter/material.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({
    super.key,
    required this.idProduction,
    required this.show,
  });

  final int idProduction;
  final Map show;

  @override
  ProductionPageState createState() => ProductionPageState();
}

class ProductionPageState extends State<ProductionPage> {
  Map production = {};
  List locations = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    loadProduction();
  }

  Future<void> loadProduction() async {
    try {
      final response =
          await callApiGet("productions/${widget.idProduction}/detail");
      if (response != null) {
        setState(() {
          production = response;
          locations = response['locations'];
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
    if (production['liked'] == false) {
      await likeProduction(production['id_production']);
    } else {
      await unlikeProduction(production['id_production']);
    }
    await loadProduction();
  }

  Future _dialog(action) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return action;
      },
    );
  }

  Future<void> tapCheck() async {
    if (production['seen'] == true) {
      final selectedAction =
          await _dialog(const ActionChoosingTapCheckLocation());
      if (selectedAction == "see again") {
        final selectedLocation =
            await _dialog(LocationChooser(locations: locations));
        if (selectedLocation != null) {
          await seeProduction(
              production['id_production'], selectedLocation['id_programming']);
        }
      }
      if (selectedAction == "unsee") {
        if (production['ids_seen'].length == 1) {
          await unseeProduction(production['ids_seen'][0]);
        } else {
          final selectedIds = await _dialog(SeenChooserProduction(
            production: production,
          ));
          if (selectedIds.length == 1) {
            await unseeProduction(selectedIds[0]);
          } else {
            for (var idSeen in selectedIds) {
              await unseeProduction(idSeen);
            }
          }
        }
      }
    } else {
      final selectedLocation =
          await _dialog(LocationChooser(locations: locations));

      if (selectedLocation != null) {
        await seeProduction(
            production['id_production'], selectedLocation['id_programming']);
      }
    }
    loadProduction();
  }

  Future<void> tapCheckLocation(location) async {
    if (location['seen'] == false) {
      await seeProduction(
          production['id_production'], location['id_programming']);
    } else {
      final selectedAction =
          await _dialog(const ActionChoosingTapCheckLocation());
      if (selectedAction == 'unsee') {
        if (location['ids_seen'].length == 1) {
          await unseeProduction(location['ids_seen'][0]);
        } else {
          final selectedSeen = await _dialog(SeenChooserLocation(
            location: location,
            idsSeen: location['ids_seen'],
          ));
          if (selectedSeen.length == 1) {
            await unseeProduction(selectedSeen[0]);
          } else {
            for (var idSeen in selectedSeen) {
              await unseeProduction(idSeen);
            }
          }
        }
      }
      if (selectedAction == 'see again') {
        await seeProduction(
            production['id_production'], location['id_programming']);
      }
    }
    loadProduction();
  }

  void navigateToShowPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPage(idShow: production['id_show']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.show['title_show'],
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
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PosterProduction(imageUrl: production['url_poster']),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: navigateToShowPage,
                                child: Text(widget.show['title_show'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              ),
                              const SizedBox(height: 16),
                              Text(production['name_production'],
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              AddToListButton(
                                  text: "Add to Wishlist",
                                  iconType: CustomIcons.like,
                                  iconState: production['liked'] ?? false,
                                  actionFunction: tapHeart),
                              AddToListButton(
                                  text: "Add to Seen list",
                                  iconType: CustomIcons.seen,
                                  iconState: production['seen'] ?? false,
                                  actionFunction: tapCheck),
                              const SizedBox(height: 16),
                              // Locations part.
                              // Title.
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  locations.length <= 1
                                      ? 'Played in ${locations.length} location'
                                      : 'Played in ${locations.length} locations',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Content.
                              locations.isNotEmpty
                                  ? LocationsContainer(
                                      locations: locations
                                          .where((location) =>
                                              location['name_location'] !=
                                              '[Unspecified location]')
                                          .toList(),
                                      tapCheckLocation: tapCheckLocation,
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

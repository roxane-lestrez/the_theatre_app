import 'package:first_app/api_service.dart';
import 'package:first_app/utils.dart';
import 'package:flutter/material.dart';

// This widget creates a container for the productions sorted in categories.

class ProductionsContainer extends StatefulWidget {
  const ProductionsContainer({
    super.key,
    required this.productions,
    required this.navigateToProductionPageFunction,
  });

  final List productions;
  final Function navigateToProductionPageFunction;

  @override
  State<ProductionsContainer> createState() => _ProductionsContainerState();
}

class _ProductionsContainerState extends State<ProductionsContainer> {
  Future<void> tapCheck(BuildContext context, int idProduction) async {
    final production = await callApiGet('productions/$idProduction/detail');

    if (production == null) return;

    final locations = production['locations'] ?? [];

    if (!context.mounted) return;

    await tapCheckProduction(
      context: context,
      production: production,
      locations: locations,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Classify categories by group.
    final groupedProductions = <int, List<Map<String, dynamic>>>{};
    final correspondanceCategories = <int, String>{};
    for (var production in widget.productions) {
      groupedProductions
          .putIfAbsent(production['id_cat'], () => [])
          .add(production);
      correspondanceCategories.putIfAbsent(
          production['id_cat'], () => production['title_cat']);
    }
    final sortedCategories = groupedProductions.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sortedCategories.map((idCat) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category title.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  correspondanceCategories[idCat]!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // List of clickable productions.
              ...groupedProductions[idCat]!.map((production) {
                return InkWell(
                  onTap: () {
                    widget.navigateToProductionPageFunction(
                        context, production);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(50, 0, 0, 0),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          production['name_production'],
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color:
                                false // Modifier ici en production['seen']==true
                                    ? Colors.green
                                    : const Color.fromARGB(255, 214, 214, 214),
                            size: 30,
                          ),
                          onPressed: () =>
                              tapCheck(context, production['id_production']),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// This widget creates a container for the productions sorted in categories.

class ProductionsContainer extends StatelessWidget {
  const ProductionsContainer({
    super.key,
    required this.sortedCategories,
    required this.groupedProductions,
    required this.correspondanceCategories,
    required this.navigateToProductionPageFunction,
  });

  final List sortedCategories;
  final Map groupedProductions;
  final Map correspondanceCategories;
  final Function navigateToProductionPageFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sortedCategories.map((id_cat) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category title.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  correspondanceCategories[id_cat],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // List of clickable productions.
              ...groupedProductions[id_cat]!.map((production) {
                return InkWell(
                  onTap: () {
                    navigateToProductionPageFunction(context, production);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      production['name_production'],
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimaryContainer),
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

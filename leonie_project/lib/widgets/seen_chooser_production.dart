import 'package:flutter/material.dart';

// This widget creates a location chooser.

class SeenChooserProduction extends StatelessWidget {
  const SeenChooserProduction({
    super.key,
    required this.production,
  });

  final Map production;

  // String formatDate(String isoDate) {
  //   final DateTime parsedDate =
  //       DateTime.parse(isoDate); // Convertir en DateTime
  //   final String formattedDate =
  //       '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
  //   return formattedDate;
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Which one do you want to delete?"),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ...production['ids_seen'].map((idSeen) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.pop(
                      context, [idSeen]); // Return the choosen location id.
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${production['locations'].where((loc) => loc['ids_seen'].contains(idSeen) == true).toList()[0]['name_location']}",
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          InkWell(
            onTap: () {
              Navigator.pop(context,
                  production['ids_seen']); // Return the choosen location id.
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delete all",
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onError),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

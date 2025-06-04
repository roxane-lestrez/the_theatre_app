import 'package:first_app/pages/text_style.dart';
import 'package:flutter/material.dart';

// This widget creates a location chooser.

class LocationChooser extends StatelessWidget {
  const LocationChooser({
    super.key,
    required this.locations,
  });

  final List locations;

  String formatDate(String isoDate) {
    final DateTime parsedDate =
        DateTime.parse(isoDate); // Convertir en DateTime
    final String formattedDate =
        '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Where did you see the show?"),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ...locations.map((location) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.pop(
                      context, location); // Return the choosen location id.
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 241, 241),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          location['name_location'],
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: location['first_date'] != null &&
                                location['last_date'] != null
                            ? Text(
                                '${formatDate(location['first_date'])} - ${formatDate(location['last_date'])}',
                                style: AppTextStyles.dates,
                              )
                            : location['first_date'] == null &&
                                    location['last_date'] != null
                                ? Text(
                                    'Until ${formatDate(location['last_date'])}',
                                    style: AppTextStyles.dates,
                                  )
                                : location['first_date'] != null &&
                                        location['last_date'] == null
                                    ? Text(
                                        'From ${formatDate(location['first_date'])}',
                                        style: AppTextStyles.dates,
                                      )
                                    : const SizedBox.shrink(),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ]),
      ),
    );
  }
}

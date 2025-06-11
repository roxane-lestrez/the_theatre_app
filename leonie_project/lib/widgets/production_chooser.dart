import 'package:first_app/pages/text_style.dart';
import 'package:flutter/material.dart';

// This widget creates a location chooser.

class ProductionChooser extends StatelessWidget {
  const ProductionChooser({
    super.key,
    required this.productions,
  });

  final List productions;

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
      title: const Text("What production did you see?"),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ...productions.map((production) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.pop(
                      context, production); // Return the choosen location id.
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
                          production['name_production'],
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: production['first_date'] != null &&
                                production['last_date'] != null
                            ? Text(
                                '${formatDate(production['first_date'])} - ${formatDate(production['last_date'])}',
                                style: AppTextStyles.dates,
                              )
                            : production['first_date'] == null &&
                                    production['last_date'] != null
                                ? Text(
                                    'Until ${formatDate(production['last_date'])}',
                                    style: AppTextStyles.dates,
                                  )
                                : production['first_date'] != null &&
                                        production['last_date'] == null
                                    ? Text(
                                        'From ${formatDate(production['first_date'])}',
                                        style: AppTextStyles.dates,
                                      )
                                    : const SizedBox.shrink(),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}

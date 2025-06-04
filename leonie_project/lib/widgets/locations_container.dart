import 'package:first_app/pages/text_style.dart';
import 'package:flutter/material.dart';

// This widget creates a container for the locations.

class LocationsContainer extends StatefulWidget {
  const LocationsContainer({
    super.key,
    required this.locations,
    required this.tapCheckLocation,
  });

  final List locations;
  final Function tapCheckLocation;

  @override
  LocationsContainerState createState() => LocationsContainerState();
}

class LocationsContainerState extends State<LocationsContainer> {
  String formatDate(String isoDate) {
    final DateTime parsedDate =
        DateTime.parse(isoDate); // Convertir en DateTime
    final String formattedDate =
        '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
    return formattedDate;
  }

  // Future<void> tapCheck(location) async {
  //   setState(() {
  //     if (location['seen'] == false) {
  //       seeProduction(production['id_production']);
  //     }
  //     } else {
  //       unseeProduction(production['id_production']);
  //     }
  //   });
  //   loadProd();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(
          height: 10,
        ),
        ...widget.locations.map((location) {
          return InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location['name_location'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        location['first_date'] != null &&
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
                                    : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  location["ids_seen"].length > 1 ? Text("x${location["ids_seen"].length}") : Text(""),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: location['seen'] == true
                          ? Colors.green
                          : const Color.fromARGB(255, 214, 214, 214),
                      size: 30,
                    ),
                    onPressed: () => widget.tapCheckLocation(location),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ]),
    );
  }
}

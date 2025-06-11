import 'package:first_app/api_service.dart';
import 'package:first_app/widgets/action_choosing_tap_check.dart';
import 'package:first_app/widgets/location_chooser.dart';
import 'package:first_app/widgets/seen_chooser_production.dart';
import 'package:flutter/material.dart';

Future dialog(BuildContext context, action) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return action;
    },
  );
}

Future<void> tapCheckProduction({
  required BuildContext context,
  required Map<dynamic, dynamic> production,
  required List locations,
}) async {
  Future<T?> dialog<T>(Widget dialog) {
    return showDialog<T>(
      context: context,
      builder: (context) => dialog,
    );
  }

  if (production['seen'] == true) {
    final selectedAction = await dialog(const ActionChoosingTapCheck());

    if (selectedAction == "see again") {
      final selectedLocation =
          await dialog(LocationChooser(locations: locations));
      if (selectedLocation != null) {
        await seeProduction(
            production['id_production'], selectedLocation['id_programming']);
      }
    }

    if (selectedAction == "unsee") {
      if (production['ids_seen'].length == 1) {
        await unseeProduction(production['ids_seen'][0]);
      } else {
        final selectedIds =
            await dialog(SeenChooserProduction(production: production));
        for (var idSeen in selectedIds) {
          await unseeProduction(idSeen);
        }
      }
    }
  } else {
    final selectedLocation =
        await dialog(LocationChooser(locations: locations));
    if (selectedLocation != null) {
      await seeProduction(
          production['id_production'], selectedLocation['id_programming']);
    }
  }
}

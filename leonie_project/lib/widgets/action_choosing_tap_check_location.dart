import 'package:flutter/material.dart';

// This widget creates a location chooser.

class ActionChoosingTapCheckLocation extends StatelessWidget {
  const ActionChoosingTapCheckLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, "see again");
                },
                child: const Center(child: Text('See again')),
              ),
            ),
            // Add vertical divider
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 1,
                width: 40,
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, "unsee");
                },
                child: const Center(child: Text('Unsee')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// This widget creates a location chooser.

class ActionChoosingTapCheck extends StatelessWidget {
  const ActionChoosingTapCheck({
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
            Container(
              width: 1,
              height: 40,
              color: Colors.black,
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

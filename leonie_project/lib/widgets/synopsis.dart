import 'package:first_app/pages/synopsis_page.dart';
import 'package:flutter/material.dart';

// This widget creates synopsis field.

class Synopsis extends StatelessWidget {
  const Synopsis({
    super.key,
    required this.synopsisContent,
  });

  final String synopsisContent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Synopsis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SynopsisPage(
                    synopsis: synopsisContent,
                  ),
                ),
              );
            },
            child: Text(
              synopsisContent,
              style: const TextStyle(fontSize: 16),
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

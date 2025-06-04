import 'package:flutter/material.dart';

// This widget creates a container for an image.

class PosterProduction extends StatelessWidget {
  const PosterProduction({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () => Navigator.pop(
                    context), // Close dialog by clicking anywhere.
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                          color: Colors
                              .transparent), // Clickable area around image.
                    ),
                    Center(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

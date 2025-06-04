import 'package:flutter/material.dart';

// This widget creates a circular container for the profile picture.

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  Widget _defaultProfileImage() {
    return const Icon(Icons.person, size: 50, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context), // Close dialog on tap
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(color: Colors.transparent),
                      ),
                      Center(
                        child: ClipOval(
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                _defaultProfileImage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: CircleAvatar(
        radius: 60, // Taille de l’image
        backgroundColor: Colors.grey[300], // Fond si pas d'image
        backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
            ? NetworkImage(imageUrl!)
            : null,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? _defaultProfileImage() // Afficher une icône si pas d’image
            : null,
      ),
    );
  }
}

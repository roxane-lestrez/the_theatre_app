import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// This widget creates a circular container for the profile picture.

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  ProfilePictureState createState() => ProfilePictureState();
}

class ProfilePictureState extends State<ProfilePicture> {
  late File _image;
  final picker = ImagePicker();
  final String routeEdit = '/edit';

  // Method for sending a selected or taken photo to the EditPage
  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.pushNamed(context, routeEdit, arguments: _image);
      } else
        print('No photo was selected or taken');
    });
  }

	/// Selection dialog that prompts the user to select an existing photo or take a new one
  Future _showSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Select from gallery'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('Take a photo'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('Show profile picture'),
              onPressed: () {
                _showPictureDialog();
              },
            ),
          ],
        );
      }
    );
  }

  Future _showPictureDialog() async {
    return showDialog(
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
                  _profilePicture(),
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _profilePicture() {
    return Center(
      child: ClipOval(
        // child: Image.network(
        //   widget.imageUrl!,
        //   fit: BoxFit.contain,
        //   errorBuilder: (context, error, stackTrace) =>
        //       _defaultProfileImage(),
        // ),
        child: Image.file(
          _image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _defaultProfileImage(),
        ),
      ),
    );
  }

  Widget _defaultProfileImage() {
    return const Icon(Icons.person, size: 50, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
          _showSelectionDialog();
        // }
      },
      child: CircleAvatar(
        radius: 60, // Taille de l’image
        backgroundColor: Colors.grey[300], // Fond si pas d'image
        backgroundImage: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            ? NetworkImage(widget.imageUrl!)
            : null,
        child: (widget.imageUrl == null || widget.imageUrl!.isEmpty)
            ? _defaultProfileImage() // Afficher une icône si pas d’image
            : null,
      ),
    );
  }
}

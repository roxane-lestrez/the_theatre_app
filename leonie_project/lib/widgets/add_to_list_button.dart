import 'package:first_app/utils/constants.dart';
import 'package:flutter/material.dart';

// This widget creates an icon button with a description to add an element to a list.

class AddToListButton extends StatelessWidget {
  const AddToListButton({
    super.key,
    required this.text,
    required this.iconType,
    required this.iconState,
    required this.actionFunction,
  });

  final String text;
  final CustomIcons iconType;
  final bool iconState;
  final Function actionFunction;
  
  Widget buildIcon(BuildContext context) {
    IconData? icon;
    Color? color;

    switch (iconType) {
      case CustomIcons.like:
        icon = Icons.favorite;
        color = likeIconColor;
      case CustomIcons.seen: 
        icon = Icons.check_circle;
        color = seenIconColor;
      default:
        icon = Icons.error;
    }

    return Icon(
      icon,
      color: iconState == true
          ? color
          : const Color.fromARGB(
              255, 214, 214, 214),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: buildIcon(context),
          iconSize: 35,
          onPressed: () => actionFunction(),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

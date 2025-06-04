import 'package:flutter/material.dart';

// This widget creates an icon button with a description to add an element to a list.

class AddToListButton extends StatelessWidget {
  const AddToListButton({
    super.key,
    required this.text,
    required this.iconButton,
    required this.actionFunction,
  });

  final String text;
  final Icon iconButton;
  final Function actionFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: iconButton,
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

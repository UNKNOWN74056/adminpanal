import 'package:flutter/material.dart';

class BuildCard extends StatefulWidget {
  final String player;
  final String imageUrl;
  const BuildCard({Key? key, required this.player, required this.imageUrl})
      : super(key: key);

  @override
  _BuildCardState createState() => _BuildCardState();
}

class _BuildCardState extends State<BuildCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(widget.imageUrl), // Display user's image
          radius: 15, // Customize the avatar radius as needed
        ),
        title: Text(
          widget.player,
          style: const TextStyle(
            // Customize the font size as needed
            fontWeight: FontWeight.bold, // Customize the font weight as needed
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          size: 15, // Customize the icon size as needed
          color: Colors.blue, // Customize the icon color as needed
        ),
      ),
    );
  }
}

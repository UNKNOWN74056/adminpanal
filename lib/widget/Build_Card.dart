import 'package:flutter/material.dart';

class BuildCard extends StatefulWidget {
  final String player;
  const BuildCard({Key? key, required this.player}) : super(key: key);

  @override
  _BuildCardState createState() => _BuildCardState();
}

class _BuildCardState extends State<BuildCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: CircleAvatar(
        //   radius: 30, // Customize the radius as needed
        //   backgroundImage:
        //       NetworkImage('URL_TO_PLAYER_IMAGE'), // Use player's image URL
        // ),
        title: Text(
          widget.player,
          style: const TextStyle(
            fontSize: 18, // Customize the font size as needed
            fontWeight: FontWeight.bold, // Customize the font weight as needed
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          size: 30, // Customize the icon size as needed
          color: Colors.blue, // Customize the icon color as needed
        ),
      ),
    );
  }
}

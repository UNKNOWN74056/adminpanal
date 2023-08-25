import 'package:flutter/material.dart';

class reusableraw extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData photo;
  const reusableraw(
      {super.key,
      required this.title,
      required this.icon,
      required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            //   color: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color.fromARGB(255, 25, 9, 117), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: Colors.white70,
            title: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            leading: CircleAvatar(
              child:Icon(photo),
            ),
            trailing: Icon(icon),
          ),
          const Divider(
            height: 15,
            //   color: Colors.black,
          )
        ],
      ),
    );
  }
}

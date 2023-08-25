import 'package:admin/clubs/clubs.dart';
import 'package:admin/tournament/turnaments.dart';
import 'package:admin/widget/adminapprove.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyadimnPage extends StatefulWidget {
  const MyadimnPage({super.key});

  @override
  State<MyadimnPage> createState() => _MyadimnPageState();
}

class _MyadimnPageState extends State<MyadimnPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Admin panel"),
            bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              tabs: [Text("Clubs"), Text("Turnaments")],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Get.to(AdminApprovalScreen());
                    },
                    child: const Icon(FontAwesomeIcons.bell)),
              )
            ],
          ),
          body: const TabBarView(children: [clubs(), turnaments()]),
        ));
  }
}

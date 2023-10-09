import 'package:admin/widget/Deletion_Requests.dart';
import 'package:admin/widget/registration.dart';
import 'package:flutter/material.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Approval'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Registration'), // Tab 1 text
              Tab(text: 'Deletion'), // Tab 2 text
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1 content
            Container(
              child: const Center(child: Registration()),
            ),

            // Tab 2 content
            Container(
              child: const Center(
                child: Deleteion_Requests(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

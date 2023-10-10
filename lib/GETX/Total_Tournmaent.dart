import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentController extends GetxController {
  final RxInt totalTournaments = 0.obs;
  late Stream<QuerySnapshot> tournamentStream;

  TournamentController() {
    initStream();
  }

  void initStream() {
    tournamentStream =
        FirebaseFirestore.instance.collection('tournaments').snapshots();
  }
}

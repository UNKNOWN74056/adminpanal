import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentRegistrationRequest {
  String teamName;
  String captainName;
  String address;
  String city;
  String contactEmail;
  String contact;
  String sportevent;
  bool isApproved; // New field
  String document;

  TournamentRegistrationRequest({
    required this.teamName,
    required this.captainName,
    required this.address,
    required this.city,
    required this.contactEmail,
    required this.contact,
    required this.sportevent,
    this.isApproved = false, // Default to false
    required this.document, // Initialize with document ID
  });

  factory TournamentRegistrationRequest.fromFirestore(
      DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TournamentRegistrationRequest(
      teamName: data['teamName'],
      captainName: data['captainName'],
      address: data['address'],
      city: data['city'],
      contactEmail: data['contactEmail'],
      contact: data['contact'],
      sportevent: data['sportevent'],
      isApproved: data['isApproved'],
      document: data['document'], // Retrieve document ID
    );
  }
}

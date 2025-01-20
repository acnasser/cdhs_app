import 'package:cloud_firestore/cloud_firestore.dart';

class JobPosting {
  String companyName;
  String jobTitle;
  String description;
  String qualifications;
  String requiredCerts;
  String responsibilities;
  String whoPosted;
  String cAddress;
  String cState;
  String zipCode;
  // String timestamp;
  double latitude;
  double longitude;

  JobPosting({
    required this.companyName,
    required this.jobTitle,
    required this.description,
    required this.qualifications,
    required this.requiredCerts,
    required this.responsibilities,
    required this.whoPosted,
    required this.cAddress,
    required this.cState,
    required this.zipCode,
    // required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to convert Firestore snapshot to JobPosting object
  factory JobPosting.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return JobPosting(
      companyName: data['CompanyName'],
      jobTitle: data['JobTitle'],
      description: data['Description'],
      qualifications: data['Qualifications'],
      requiredCerts: data['RequiredCerts'],
      responsibilities: data['Responsibilities'],
      whoPosted: data['WhoPosted'],
      cAddress: data['CAddress'],
      cState: data['CState'],
      zipCode: data['ZipCode'],
      // timestamp: data['timestamp'],
      latitude: data['latitude'] ?? 0.0, // Add default latitude if missing
      longitude: data['longitude'] ?? 0.0, // Add default longitude if missing
    );
  }
}

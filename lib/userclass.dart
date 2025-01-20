import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
  
class Userclass {

 static Future<Map<String, dynamic>> fetchCurrentUserData() async {
    try {
      // Get the current user from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Reference to Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Fetch the user document using the current user's UID
        DocumentSnapshot userDoc = await firestore
            .collection('Users')
            .doc(currentUser.uid)  // Use current user's UID to get their document
            .get();

        // Check if the document exists
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        } else {
          print('User document not found');
          return {};  // Return empty map if no document found
        }
      } else {
        print('No user is currently logged in');
        return {};  // Return empty map if no user is logged in
      }
    } catch (e) {
      print('Error fetching current user data: $e');
      return {};  // Return empty map in case of error
    }
  }
}
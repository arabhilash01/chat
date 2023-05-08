import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> registerUser(String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('userDetails').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'displayName': displayName,
        'photoUrl': null, // Set a default photo URL if you don't have it yet
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

//   static Future<void> registerWithEmailAndPassword(String email, String password, String displayName) async {
//   try {
//     // Create a new user with email and password
//     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     // Add the user details to Firestore collection
//     await FirebaseFirestore.instance.collection('userDetails').doc(userCredential.user!.uid).set({
//       'uid': userCredential.user!.uid,
//       'email': userCredential.user!.email,
//       'displayName': displayName,
//       'photoUrl': null, // Set a default photo URL if you don't have it yet
//     });
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       print('The password provided is too weak.');
//     } else if (e.code == 'email-already-in-use') {
//       print('The account already exists for that email.');
//     }
//   } catch (e) {
//     print(e);
//   }
// }

  static Future<UserCredential?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<List<Users>> getUsers() async {
    final List<Users> users = [];

    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection('userDetails');
      final QuerySnapshot querySnapshot = await collection.get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      print('Doc len');
      print(documents.length);
      documents.forEach((document) {
        final Users user = Users(
          uid: (document.data() as Map<String, dynamic>)['uid'],
          email: (document.data() as Map<String, dynamic>)['email'],
          displayName: (document.data() as Map<String, dynamic>)['displayName'],
          photoUrl: (document.data() as Map<String, dynamic>)['photoUrl'],
        );
        users.add(user);
      });
    } catch (e) {
      print('Error getting users: $e');
    }

    return users;
  }
}

class Users {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;

  Users({required this.uid, required this.email, required this.displayName, required this.photoUrl});
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createChat(String userId, String recipientId) async {
    try {
      // Generate a new chat ID
      String chatId = _firestore.collection('chats').doc().id;
      // Add the chat ID to the users' chat lists
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chatId)
          .set({'recipientId': recipientId});
      await _firestore
          .collection('users')
          .doc(recipientId)
          .collection('chats')
          .doc(chatId)
          .set({'recipientId': userId});

      // Create the chat document with an empty messages array
      await _firestore.collection('chats').doc(chatId).set({'messages': []});
    } catch (e) {
      print(e.toString());
    }
  }

  static Stream<List<QueryDocumentSnapshot>> streamChats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  static Future<String> getDisplayName(String uid) async {
    String userName = '';

    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userDetails').where('uid', isEqualTo: uid).get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      if (documents.isNotEmpty) {
        final Map<String, dynamic> data = documents.first.data() as Map<String, dynamic>;
        userName = data['displayName'] as String;
      }
    } catch (e) {
      print('Error getting display name: $e');
    }

    return userName;
  }
}

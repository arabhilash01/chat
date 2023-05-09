import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> createChat(String userId, String recipientId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> existingChatSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .where('recipientId', isEqualTo: recipientId)
          .limit(1)
          .get();

      if (existingChatSnapshot.docs.isNotEmpty) {
        // Chat already exists, return the existing chat ID
        return existingChatSnapshot.docs[0].id;
      }
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
      return chatId;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  static Stream<List<ChatRoomModel>> streamChats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((chatDoc) {
              final chatData = chatDoc.data();
              final recipientId = chatData['recipientId'] as String;
              return ChatRoomModel(
                chatRoomId: chatDoc.id,
                recipientId: recipientId,
              );
            }).toList());
  }

  static Future<String> getReciepientId(String userId, String chatId) async {
    final value = await _firestore.collection('users').doc(userId).collection('chats').doc(chatId).get();
    String displayName = await getDisplayName(value['recipientId']);
    return displayName;
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

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore.collection('chats').doc(chatId).snapshots();
  }

  static Future<void> sendMessage(String chatId, String senderId, String text) async {
    try {
      final chatDoc = _firestore.collection('chats').doc(chatId);
      final chatData = await chatDoc.get();
      final messages = List.from(chatData.data()?['messages'] ?? []);

      messages.add({
        'id': messages.length,
        'from': senderId,
        'text': text,
        'timestamp': Timestamp.now(),
      });

      await chatDoc.update({'messages': messages});
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

class ChatRoomModel {
  final String chatRoomId;
  final String recipientId;

  ChatRoomModel({
    required this.chatRoomId,
    required this.recipientId,
  });
}

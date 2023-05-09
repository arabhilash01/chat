import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/screens/chatroom.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Users user;
  final String query;
  const ContactCard({super.key, required this.user, required this.query});

  @override
  Widget build(BuildContext context) {
    int querySubstringIndex = user.displayName.toUpperCase().indexOf(
          query.toUpperCase(),
        );
    return ListTile(
      onTap: () async {
        String chatRoomId = await FireStoreHelper.createChat(FirebaseHelper.currentUserUid, user.uid);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatRoom(
            chatRoomId: chatRoomId,
          ),
        ));
      },
      title: RichText(
        text: TextSpan(
          text: user.displayName.substring(
            0,
            querySubstringIndex,
          ),
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: user.displayName.substring(
                querySubstringIndex,
                querySubstringIndex + query.length,
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: user.displayName.substring(
                querySubstringIndex + query.length,
              ),
            ),
          ],
        ),
      ),
      leading: const Icon(Icons.person),
    );
  }
}

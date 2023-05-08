import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/screens/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: FireStoreHelper.streamChats('sgc2hts1sCU9bIrWQ2133KIuosi1'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                String chatName = chats[index].id;
                return ListTile(
                  title: Text(chatName),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatRoom(
                        chatRoomId: chats[index].id,
                      ),
                    ));
                    // Navigate to the chat room
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Failed to load chats: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return FutureBuilder(
              future: FirebaseHelper.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data == null) {
                  return const Text('No registered Users found');
                } else {
                  return ListView(
                    children: [
                      for (Users i in snapshot.data!)
                        ListTile(
                          title: Text(i.displayName),
                          subtitle: Text(i.email),
                        )
                    ],
                  );
                }
              },
            );
          },
        );
      }),
    );
  }
}

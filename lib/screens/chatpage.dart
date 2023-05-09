import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/screens/chatroom.dart';
import 'package:chatapplication/utils/searchuser.dart';
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
        actions: [
          IconButton(
              onPressed: () {
                FirebaseHelper.signOutUser();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: FireStoreHelper.streamChats(FirebaseHelper.currentUserUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatRoomModel> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FireStoreHelper.getReciepientId(FirebaseHelper.currentUserUid, chats[index].chatRoomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(snapshot.data ?? 'No Data'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              chatRoomId: chats[index].chatRoomId,
                            ),
                          ),
                        );
                      },
                    );
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showSearch(context: context, delegate: UsersSearch());
          }),
    );
  }
}

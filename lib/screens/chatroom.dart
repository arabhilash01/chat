import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/utils/datetime.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.chatRoomId});
  final String chatRoomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FireStoreHelper.getReciepientId(FirebaseHelper.currentUserUid, widget.chatRoomId);
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: FireStoreHelper.getReciepientId(FirebaseHelper.currentUserUid, widget.chatRoomId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            } else {
              return Text(snapshot.data ?? 'No Data Found');
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FireStoreHelper.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i in snapshot.data!['messages'])
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: i['from'] == FirebaseHelper.currentUserUid
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: i['from'] == FirebaseHelper.currentUserUid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person),
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: i['from'] == FirebaseHelper.currentUserUid ? Colors.green : Colors.blue,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(i['text']),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(formatDate(i['timestamp'])),
                              )
                            ],
                          ),
                        )
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    FireStoreHelper.sendMessage(
                      widget.chatRoomId,
                      FirebaseHelper.currentUserUid,
                      _textController.text,
                    );
                    _textController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

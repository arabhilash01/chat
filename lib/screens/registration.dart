import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/screens/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
  final TextEditingController _userNameContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Hero(
                tag: 'Logo',
                child: Image.network(
                    'https://images.unsplash.com/photo-1545231027-637d2f6210f8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bG9nb3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60')),
          ),
          // Hero Animation
          TextFormField(
            controller: _emailContoller,
            decoration: const InputDecoration(hintText: 'Enter our Email Address'),
          ),
          TextFormField(
            controller: _userNameContoller,
            decoration: const InputDecoration(hintText: 'Enter your Name'),
          ),
          TextFormField(
            controller: _passwordContoller,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter our Password'),
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseHelper.registerUser(_emailContoller.text, _passwordContoller.text,_userNameContoller.text);
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatListScreen(),
                  ));
                }
              },
              child: const Text('Register'))
        ],
      ),
    );
  }
}

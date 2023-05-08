import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/screens/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
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
            controller: _passwordContoller,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter our Password'),
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseHelper.signInUser(_emailContoller.text, _passwordContoller.text);
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatListScreen(),
                  ));
                }
              },
              child: const Text('Login'))
        ],
      ),
    );
  }
}

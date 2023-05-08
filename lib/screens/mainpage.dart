import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/screens/login.dart';
import 'package:chatapplication/screens/registration.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: 600,
                // height: 200,
                child: Hero(
                  tag: 'logo',
                  child: Image.network(
                    'https://images.unsplash.com/photo-1545231027-637d2f6210f8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bG9nb3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
                child: const Text('Login')),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ));
            }, child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}

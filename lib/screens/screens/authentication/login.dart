
import 'package:flutter/material.dart';
import 'package:torva/Services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final AuthService _auth = AuthService();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log In")),
      body: ElevatedButton(
        onPressed: () async {
          dynamic result = await _auth.signInAnonymously();
          if (result == Null) {
            print("error in sign in anon");
          } else {
            print("sign in succsuss");
            print(result.uid);
          }
        },
        child: Text("Sign In"),
      ),
    );
  }
}

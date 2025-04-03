
import 'package:flutter/material.dart';
import 'package:torva/screens/screens/authentication/authenticate.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final bool isverified = true;
  @override
  Widget build(BuildContext context) {
    return Authanticate();
  }
}

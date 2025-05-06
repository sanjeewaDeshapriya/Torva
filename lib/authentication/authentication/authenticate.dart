import 'package:flutter/material.dart';
// import 'package:torva/screens/screens/authentication/login.dart';
import 'package:torva/authentication/authentication/regester.dart';

class Authanticate extends StatefulWidget {
  const Authanticate({super.key});

  @override
  State<Authanticate> createState() => _AuthanticateState();
}

class _AuthanticateState extends State<Authanticate> {
  @override
  Widget build(BuildContext context) {
    return Regester();
  }
}

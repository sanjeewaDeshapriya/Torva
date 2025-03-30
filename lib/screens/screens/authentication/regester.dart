import 'package:flutter/material.dart';

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Regester")));
  }
}
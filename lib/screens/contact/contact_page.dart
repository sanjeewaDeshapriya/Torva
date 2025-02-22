import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String _name = 'John Doe';

  void _changeName() {
    setState(() {
      _name = 'Jane Doe';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact Name: $_name'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _changeName, child: Text('Change Name')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

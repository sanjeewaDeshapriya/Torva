import 'package:flutter/material.dart';
import 'package:torva/Services/auth.dart';
import 'package:torva/widgets/info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7033FA)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    100,
                  ), // Adjust the radius for rounding
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/profile1.jpg',
                    ), // Change as needed
                    fit: BoxFit.cover, // Adjust how the image fits
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'NippaX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text('2560 Points', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              InfoCard(
                icon: Icons.person_outline,
                title: 'Personal Information',
              ),
              SizedBox(height: 10),
              InfoCard(icon: Icons.assignment_turned_in, title: 'Finds'),
              SizedBox(height: 10),
              InfoCard(icon: Icons.key, title: 'Hides'),
              SizedBox(height: 10),
              InfoCard(icon: Icons.file_present_sharp, title: 'Add Treasure'),
              SizedBox(height: 10),
              InfoCard(icon: Icons.settings, title: 'Settings'),
              SizedBox(height: 10),
              InfoCard(
                icon: Icons.exit_to_app,
                title: 'Exit',
                onTap: () async {
                  print('Exit tapped');

                  await _auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/wrapper');
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

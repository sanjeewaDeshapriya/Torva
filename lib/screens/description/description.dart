import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DescriptionScreen(),
    );
  }
}

class DescriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Description',
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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Color(0xFF7033FA)),
            onPressed: () {},
          ),
        ],
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
                      10), // Adjust the radius for rounding
                  image: DecorationImage(
                    image: AssetImage('assets/profile1.jpg'), // Change as needed
                    fit: BoxFit.cover, // Adjust how the image fits
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'GOMAN Treasure',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text('#GC48Q9K', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (index) => Icon(Icons.local_fire_department,
                        color: Color(0xFF7033FA))),
              ),
              SizedBox(height: 20),
              InfoCard(
                  icon: Icons.person_outline,
                  title: 'Placed by',
                  value: 'Rave'),
              SizedBox(height: 10),
              InfoCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Date',
                  value: '2025-01-18'),
              SizedBox(height: 10),
              InfoCard(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: 'Pitipana, Homagama'),
              SizedBox(height: 10),
              InfoCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Hint',
                  value: 'Lorem ipsum dolor...'),
              SizedBox(height: 10),
              InfoCard(
                  icon: Icons.description_outlined,
                  title: 'Description',
                  value: 'Lorem ipsum dolor...'),
              SizedBox(height: 10),
              InfoCard(
                  icon: Icons.history_outlined,
                  title: 'Past Logs',
                  value: 'Found it on 2025-...'),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 243, 245),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: const Text(
                                  'Navigate',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your save functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7033FA),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: const Text(
                                  'Log Cache',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  InfoCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF7033FA),
          size: 30,
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}

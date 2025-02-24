import 'package:flutter/material.dart';
import 'package:torva/screens/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaderboardScreen(),
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex = 0; // Track selected index for bottom navigation

  final List<Map<String, dynamic>> users = [

    {'name': 'Rathne', 'points': 9558, 'image': 'assets/profile1.jpg', 'rank': 1},
    {'name': 'NippaX', 'points': 6589, 'image': 'assets/profile1.jpg', 'rank': 2},
    {'name': 'ItsMeJithe', 'points': 1582, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Chikuba', 'points': 2560, 'image': 'assets/profile1.jpg', 'rank': 3},
    {'name': 'Rave', 'points': 2560, 'image': 'assets/profile1.jpg', 'rank': 4},
    {'name': 'Samiya', 'points': 4120, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Samiya', 'points': 4120, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Samiya', 'points': 4120, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Samiya', 'points': 4120, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Samiya', 'points': 4120, 'image': 'assets/profile1.jpg', 'rank': 5},
    {'name': 'Sanju', 'points': 782, 'image': 'assets/profile1.jpg', 'rank': 6},
    {'name': 'Rathne', 'points': 9558, 'image': 'assets/profile1.jpg', 'rank': 1},
    {'name': 'KingAshan', 'points': 2550, 'image': 'assets/profile1.jpg', 'rank': 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontSize: 28,
            fontWeight: FontWeight.bold,
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
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return leaderboardItem(users[index]);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home_max_rounded, color: _selectedIndex == 0 ? Color(0xFF7033FA) : Colors.grey, size: 40),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite_border_outlined, color: _selectedIndex == 1 ? Color(0xFF7033FA) : Colors.grey, size: 40),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.emoji_events_outlined, color: _selectedIndex == 2 ? Color(0xFF7033FA) : Colors.grey, size: 40),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: _selectedIndex == 3 ? Color(0xFF7033FA) : Colors.grey, size: 40),
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget leaderboardItem(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(user['image']),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                Text("${user['points']} Points",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                user['rank'] <= 3
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: user['rank'] == 1
                    ? Colors.yellow
                    : user['rank'] == 2
                        ? Colors.grey
                        : user['rank'] == 3
                            ? Colors.brown
                            : Color(0xFF7033FA),
                size: 40,
              ),
              Text(
                user['rank'].toString(),
                style: TextStyle(
                  color: user['rank'] <= 3 ? Colors.white : Color(0xFF7033FA),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

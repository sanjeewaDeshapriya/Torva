import 'package:flutter/material.dart';
import 'package:torva/screens/addTreasure/addTreasure_page.dart';
import 'package:torva/screens/leadingBoard/leadingBoard_page.dart'; // Make sure this import is correct
import 'package:torva/screens/profile/profile_page.dart';
import 'package:torva/screens/treasurelist/treasure_list.dart';
import 'package:torva/screens/wishlist/wishlist.dart';
// import 'package:torva/widgets/app_bar.dart'; // This import was not used, removed for cleanliness

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define the list of pages corresponding to the bottom navigation bar items.
  // Ensure the order matches the order of BottomNavigationBarItem widgets.
  final List<Widget> _pages = [
    const TreasureListScreen(), // Index 0: Home icon
    const WishlistScreen(),     // Index 1: Favorite icon
    const AddTreasurePage(),    // Index 2: Add icon
    const ProfilePage(),        // Index 3: Person icon (for profile)
    const LeaderboardScreen(),  // Index 4: Leaderboard icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the selected page from the _pages list.
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7033FA),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // Empty label for cleaner look, as per original code
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events), // Icon for the Leaderboard
            label: '',
          ),
        ],
        currentIndex: _selectedIndex, // The currently selected tab
        onTap: (index) {
          // Update the selected index when a tab is tapped,
          // which will rebuild the widget and show the corresponding page.
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
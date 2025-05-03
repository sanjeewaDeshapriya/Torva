import 'package:flutter/material.dart';
import 'package:torva/screens/addTreasure/addTreasure_page.dart';
import 'package:torva/screens/profile/profile_page.dart';
import 'package:torva/screens/treasurelist/treasure_list.dart';
import 'package:torva/screens/wishlist/wishlist.dart';
import 'package:torva/widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    TreasureListScreen(),
    WishlistScreen(),
    AddTreasurePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7033FA),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages[_selectedIndex],

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Welcome to the Home Page!'),
      //       SizedBox(height: 20),

      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/about');
      //         },
      //         child: Text('Go to About Page'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/contact');
      //         },
      //         child: Text('Go to Contact Page'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/addTreasure');
      //         },
      //         child: Text('Go to Add Tresure Page'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/description');
      //         },
      //         child: Text('Go to Description Page'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/leadingboard');
      //         },
      //         child: Text('Go to Leading Board'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/profilepage');
      //         },
      //         child: Text('Go to ProfilePage'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/treasurelist');
      //         },
      //         child: Text('Go to treasurelist'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:torva/screens/description/description.dart';
import 'package:torva/screens/leadingBoard/leadingBoard.dart';
import 'package:torva/screens/profile/profile_page.dart';
import '../screens/home/home_page.dart';
import '../screens/about/about_page.dart';
import '../screens/contact/contact_page.dart';
import '../screens/addTreasure/addTreasure.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String addTreasure = '/addTreasure';
  static const String description = '/description';
  static const String leadingboard = '/leadingboard';
  static const String profilepage = '/profilepage';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => ProfilePage(),
      about: (context) => AboutPage(),
      contact: (context) => ContactPage(),
      addTreasure: (context) => AddTreasurePage(),
      description: (context) => DescriptionScreen(),
      leadingboard: (context) => LeaderboardScreen(),
      profilepage: (context) => ProfilePage(),
    };
  }
}

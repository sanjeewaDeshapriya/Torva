import 'package:flutter/material.dart';

import 'package:torva/screens/description/description_page.dart';
import 'package:torva/screens/home/home_page.dart';
import 'package:torva/screens/leadingBoard/leadingBoard_page.dart';
import 'package:torva/screens/profile/profile_page.dart';
import 'package:torva/screens/screens/authentication/login.dart';
import 'package:torva/screens/screens/wrapper.dart';
import '../screens/about/about_page.dart';
import '../screens/contact/contact_page.dart';
import '../screens/addTreasure/addTreasure_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String addTreasure = '/addTreasure';
  static const String description = '/description';
  static const String leadingboard = '/leadingboard';
  static const String profilepage = '/profilepage';
  static const String wrapper = '/wrapper';
  static const String login = '/login';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => Wrapper(),
      about: (context) => AboutPage(),
      contact: (context) => ContactPage(),
      addTreasure: (context) => AddTreasurePage(),
      description: (context) => DescriptionScreen(),
      leadingboard: (context) => LeaderboardScreen(),
      profilepage: (context) => ProfilePage(),
      wrapper: (context) => Wrapper(),
      login: (context) => Login(),
    };
  }
}

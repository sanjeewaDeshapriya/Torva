import 'package:flutter/material.dart';
import '../screens/home/home_page.dart';
import '../screens/about/about_page.dart';
import '../screens/contact/contact_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String contact = '/contact';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomePage(),
      about: (context) => AboutPage(),
      contact: (context) => ContactPage(),
    };
  }
}

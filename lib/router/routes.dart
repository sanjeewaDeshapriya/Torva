import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import '../screens/home/home_page.dart';
=======
import 'package:torva/screens/description/description_page.dart';
// import 'package:torva/screens/home/home_page.dart';
import 'package:torva/screens/leadingBoard/leadingBoard_page.dart';
import 'package:torva/screens/profile/profile_page.dart';
import 'package:torva/screens/screens/wrapper.dart';

>>>>>>> Stashed changes
import '../screens/about/about_page.dart';
import '../screens/contact/contact_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String contact = '/contact';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
<<<<<<< Updated upstream
      home: (context) => HomePage(),
=======
      home: (context) =>Wrapper() ,
>>>>>>> Stashed changes
      about: (context) => AboutPage(),
      contact: (context) => ContactPage(),
    };
  }
}

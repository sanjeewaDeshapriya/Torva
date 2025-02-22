import 'package:flutter/material.dart';
import 'package:torva/theme/app_theme.dart';
import 'router/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Torva',
      theme: AppTheme.lightTheme, // Use light theme
      darkTheme: AppTheme.darkTheme, // Use dark theme
      themeMode: ThemeMode.system, // Use system theme

      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}

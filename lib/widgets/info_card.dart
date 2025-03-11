import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF7033FA), size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.value, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Color(0xFF7033FA), size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing:
            value != null
                ? Text(value!, style: TextStyle(color: Colors.grey[700]))
                : Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7033FA),
                  size: 20,
                ),
      ),
    );
  }
}

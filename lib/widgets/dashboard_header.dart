import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome, Teacher',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Your educational sanctuary is ready. Manage your classroom and track progress with effortless clarity.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SimpleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? backgroundColor;

  const SimpleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(16),
        dashPattern: [10, 5],
        strokeWidth: 2,
        //padding: EdgeInsets.all(16),
      ),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE6F2FF),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

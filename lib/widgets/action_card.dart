import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          /// 🔵 Decorative Shape (Top Right)
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2FF),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          /// 🔹 Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0B5ED7),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(height: 16),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(subtitle, style: const TextStyle(color: Colors.black54)),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5ED7),
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Start Session',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: const [
        OverviewCard(title: 'ACTIVE CLASSES', value: '04', icon: Icons.school),
        OverviewCard(title: 'STUDENTS', value: '124', icon: Icons.groups),
        OverviewCard(
          title: 'AVERAGE GRADE',
          value: 'B+',
          icon: Icons.bar_chart,
        ),
        OverviewCard(title: 'SUBMISSIONS', value: '12', icon: Icons.assignment),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Big background icon
          // Positioned(
          //   bottom: -8,
          //   right: -4,
          //   child: Icon(icon, size: 80, color: Colors.black.withOpacity(0.07)),
          // ),
          // Title and value
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 80, color: Color(0xFF006692)),
              SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

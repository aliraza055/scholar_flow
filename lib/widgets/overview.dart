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
        OverviewCard(title: 'ACTIVE CLASSES', value: '04'),
        OverviewCard(title: 'STUDENTS', value: '124'),
        OverviewCard(title: 'AVERAGE GRADE', value: 'B+'),
        OverviewCard(title: 'SUBMISSIONS', value: '12'),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;

  const OverviewCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

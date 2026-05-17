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
      childAspectRatio: 0.95,
      children: const [
        OverviewCard(
          title: 'Active Classes',
          value: '04',
          icon: Icons.school_rounded,
          accentColor: Color(0xFF1A73E8),
          bgColor: Color(0xFFEBF3FE),
          trend: 'On track',
          trendUp: true,
        ),
        OverviewCard(
          title: 'Students',
          value: '124',
          icon: Icons.groups_rounded,
          accentColor: Color(0xFF7C3AED),
          bgColor: Color(0xFFF3EFFE),
          trend: '+3 this week',
          trendUp: true,
        ),
        OverviewCard(
          title: 'Average Grade',
          value: 'B+',
          icon: Icons.bar_chart_rounded,
          accentColor: Color(0xFF10B981),
          bgColor: Color(0xFFECFDF5),
          trend: 'Good standing',
          trendUp: true,
        ),
        OverviewCard(
          title: 'Submissions',
          value: '12',
          icon: Icons.assignment_rounded,
          accentColor: Color(0xFFF59E0B),
          bgColor: Color(0xFFFFF8EB),
          trend: '3 pending',
          trendUp: false,
        ),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final String trend;
  final bool trendUp;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Icon Badge ──
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),

          // ── Value + Label + Trend ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              // ── Trend Badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 10,
                      color: accentColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

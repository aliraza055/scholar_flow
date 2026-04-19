import 'package:flutter/material.dart';

class RecordAchievementPage extends StatefulWidget {
  const RecordAchievementPage({super.key});

  @override
  State<RecordAchievementPage> createState() => _RecordAchievementPageState();
}

class _RecordAchievementPageState extends State<RecordAchievementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 22),
            const Text(
              "Record Achievement",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Log new grades into the student registry with clarity and ease.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            const SizedBox(height: 30),

            // Student Details Section
            _buildInputCard(
              icon: Icons.group_add,
              iconBgColor: const Color(0xFFE0E0FF),
              iconColor: const Color(0xFF6366F1),
              title: "Student Details",
              label: "STUDENT ROLL NUMBER",
              hint: "e.g F22NDOCS1M1022",
              suffixIcon: Icons.fingerprint,
            ),

            const SizedBox(height: 16),

            // Assessment Info Section
            _buildInputCard(
              icon: Icons.assignment,
              iconBgColor: const Color(0xFFE0F2FE),
              iconColor: const Color(0xFF0EA5E9),
              title: "Assessment Info",
              label: "ASSIGNMENT / QUIZ TITLE",
              hint: "Final Semester Research Paper",
              suffixIcon: Icons.edit_document,
            ),

            const SizedBox(height: 16),

            // Total Marks Section
            _buildSimpleInputCard(
              label: "TOTAL MARKS",
              hint: "100",
              suffixIcon: Icons.bar_chart,
            ),

            const SizedBox(height: 16),

            // Obtained Marks Section
            _buildSimpleInputCard(
              label: "OBTAINED MARKS",
              hint: "0",
              suffixIcon: Icons.stars,
              isUnderlined: true,
            ),

            const SizedBox(height: 30),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                label: const Text(
                  "Confirm and Post Grade",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006692),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Text(
              "Grades will be immediately visible in the student sanctuary dashboard.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper for Section Cards with Header Icons
  Widget _buildInputCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String label,
    required String hint,
    required IconData suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFE5E9F0),
              suffixIcon: Icon(suffixIcon, color: Colors.blueGrey, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Simple Numeric Input Cards
  Widget _buildSimpleInputCard({
    required String label,
    required String hint,
    required IconData suffixIcon,
    bool isUnderlined = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006692),
              letterSpacing: 0.5,
            ),
          ),
          TextField(
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD1D5DB),
            ),
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: Icon(suffixIcon, color: const Color(0xFF006692)),
              enabledBorder: isUnderlined
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    )
                  : InputBorder.none,
              focusedBorder: isUnderlined
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    )
                  : InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}

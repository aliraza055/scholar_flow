import 'package:flutter/material.dart';

class NewEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f6f8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Academic Sanctuary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications),
                ],
              ),

              SizedBox(height: 20),

              /// Title
              Text(
                "New Entry",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 5),

              Text(
                "Expand your classroom records with a new student profile.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 20),

              /// Form Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Student Name
                      Text(
                        "STUDENT NAME",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      _buildTextField(
                        hint: "e.g. Julianne Sterling",
                        icon: Icons.person,
                      ),

                      SizedBox(height: 15),

                      /// Roll Number
                      Text(
                        "ROLL NUMBER",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      _buildTextField(hint: "ID-2024-001", icon: Icons.badge),

                      SizedBox(height: 15),

                      /// Class/Semester
                      Text(
                        "CLASS / SEMESTER",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      _buildTextField(
                        hint: "Select educational stage",
                        icon: Icons.school,
                        isDropdown: true,
                      ),

                      SizedBox(height: 20),

                      /// Info Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff0d5c7d), Color(0xff5fa8d3)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Academic Integrity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Ensure all data matches the institutional database for accurate grade synchronization.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      Spacer(),

                      /// Save Button
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff0d5c7d),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.save),
                          label: Text("Save Profile"),
                        ),
                      ),

                      SizedBox(height: 10),

                      /// Cancel
                      Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xff0d5c7d),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      /// Bottom Status
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 10, color: Colors.blue),
                              SizedBox(width: 6),
                              Text("DATABASE SYNC ACTIVE"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isDropdown = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xffeef1f4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        readOnly: isDropdown,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }
}

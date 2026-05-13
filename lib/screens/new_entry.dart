import 'package:flutter/material.dart';
import 'package:scholar_flow/Services/firebase_services.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';
import 'package:scholar_flow/widgets/textfeild.dart';

class NewEntryScreen extends StatefulWidget {
  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final _nameContoller = TextEditingController();
  final _rollContoller = TextEditingController();
  final _classContoller = TextEditingController();
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
                      AppTextFormField(
                        controller: _nameContoller,
                        hint: "e.g. Umar Aslam",
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
                      AppTextFormField(
                        controller: _rollContoller,
                        hint: "F22NDOCS1M1022",
                        icon: Icons.badge,
                      ),

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
                      AppTextFormField(
                        controller: _classContoller,
                        hint: "8th_C",
                        icon: Icons.school,
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
                          onPressed: () {
                            if (_nameContoller.text.isNotEmpty ||
                                _rollContoller.text.isNotEmpty ||
                                _classContoller.text.isNotEmpty) {
                              FirebaseServices().uploadStudent(
                                context,
                                name: _nameContoller.text,
                                rollNo: _rollContoller.text,
                                semester: _classContoller.text,
                              );
                            } else {
                              ToastError().showToast(
                                message: 'please fulfil the data ',
                                bgColor: Colors.red,
                              );
                            }
                          },
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            "Save Profile",
                            style: TextStyle(color: Colors.white),
                          ),
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

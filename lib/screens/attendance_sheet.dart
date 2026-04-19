import 'package:flutter/material.dart';
import 'package:scholar_flow/widgets/app_bar.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> students = [
    {"name": "Dil Rubaz", "id": "F22NDOCS1M1004", "present": true},
    {"name": "Amber", "id": "F22NDOCS1M1005", "present": true},
    {"name": "Laiba", "id": "F22NDOCS1M1006", "present": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      backgroundColor: Color(0xfff4f6f8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            /// Top Bar
            /// Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Class Attendance",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mark the presence for today's session",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 20),

            /// Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Software Quality Assurance"),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),

            SizedBox(height: 15),

            /// Info Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF006692),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "3 ENROLLED",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF006692),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "April 24, 2026",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// Student List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  var student = students[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.person, color: Color(0xFF006692)),
                        ),
                        SizedBox(width: 12),

                        /// Name + ID
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${student["id"]}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        /// Switch
                        Switch(
                          value: student["present"],
                          activeColor: Colors.white, // button (thumb)
                          activeTrackColor: Color(0xFF006692), // ON background
                          onChanged: (val) {
                            setState(() {
                              student["present"] = val;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Submit Button
            Container(
              width: double.infinity,
              height: 55,
              margin: EdgeInsets.only(bottom: 100),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0d5c7d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Submit Attendance",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

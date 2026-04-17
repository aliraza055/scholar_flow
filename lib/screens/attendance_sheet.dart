import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> students = [
    {"name": "Alex Stanford", "id": "#882910", "present": true},
    {"name": "Julianne Moore", "id": "#882911", "present": true},
    {"name": "Ethan Kovak", "id": "#882912", "present": false},
    {"name": "Leo Rodriguez", "id": "#882915", "present": true},
    {"name": "Sarah Chen", "id": "#882918", "present": true},
  ];

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
                    Text("Advanced Quantum Mechanic"),
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
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("24 ENROLLED"),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("OCT 24, 2023"),
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
                            child: Icon(Icons.person),
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
                                  "ID: ${student["id"]}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          /// Switch
                          Switch(
                            value: student["present"],
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
                margin: EdgeInsets.only(bottom: 10),
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              /// Bottom Navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.dashboard, color: Colors.grey),
                        Text("Dashboard", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.blue),
                        Text(
                          "Attendance",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.show_chart, color: Colors.grey),
                        Text(
                          "Performance",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

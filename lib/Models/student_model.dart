import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String name;
  final String email;
  final String rollNo;
  final String department;
  final int semester;
  final String phone;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.phone,
    required this.createdAt,
  });

  /// Send data to Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "rollNo": rollNo,
      "department": department,
      "semester": semester,
      "phone": phone,
      "createdAt": createdAt,
    };
  }

  /// Get data FROM Firestore
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      rollNo: map["rollNo"] ?? "",
      department: map["department"] ?? "",
      semester: map["semester"] ?? 0,
      phone: map["phone"] ?? "",
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }
}

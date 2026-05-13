import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String name;
  final String rollNo;
  final String semester;
  final String teacherId;
  final String? imgUrl;
  final DateTime? createdAt;

  StudentModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.semester,
    required this.teacherId,
    this.imgUrl,
    this.createdAt,
  });

  /// Send data to Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "rollNo": rollNo,
      "semester": semester,
      "teacherId": teacherId,
      "createdAt": createdAt,
      "imgUrl": imgUrl,
    };
  }

  /// Get data FROM Firestore
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      rollNo: map["rollNo"] ?? "",
      semester: map["semester"] ?? 0,
      teacherId: map['teacherId'] ?? '',
      createdAt: map["createdAt"] != null
          ? (map["createdAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent }

class AttendanceModel {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNo;
  final String teacherId;
  final AttendanceStatus status;
  final DateTime date;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNo,
    required this.teacherId,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'rollNo': rollNo,
      'teacherId': teacherId,
      'status': status.name, // "present" or "absent"
      'date': Timestamp.fromDate(date),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      rollNo: map['rollNo'] ?? '',
      teacherId: map['teacherId'] ?? '',
      status: map['status'] == 'present'
          ? AttendanceStatus.present
          : AttendanceStatus.absent,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}

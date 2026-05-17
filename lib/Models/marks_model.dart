class MarksModel {
  final String subject;
  final double midterm;
  final double finalMarks;
  final double total;
  final String grade;

  MarksModel({
    required this.subject,
    required this.midterm,
    required this.finalMarks,
    required this.total,
    required this.grade,
  });

  // Firestore se data lena
  factory MarksModel.fromMap(Map<String, dynamic> map) {
    return MarksModel(
      subject: map['subject'] ?? '',
      midterm: (map['midterm'] ?? 0).toDouble(),
      finalMarks: (map['final'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      grade: map['grade'] ?? '',
    );
  }

  // Firestore mein save karna
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'midterm': midterm,
      'final': finalMarks,
      'total': total,
      'grade': grade,
    };
  }

  // Grade calculate karna
  static String calculateGrade(double total) {
    if (total >= 90) return 'A+';
    if (total >= 85) return 'A';
    if (total >= 80) return 'B+';
    if (total >= 75) return 'B';
    if (total >= 70) return 'C+';
    if (total >= 60) return 'C';
    if (total >= 50) return 'D';
    return 'F';
  }

  // GPA calculate karna (4.0 scale)
  static double gradeToGPA(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }
}

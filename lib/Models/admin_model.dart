class TeacherModel {
  String? id;
  String name;
  String gmail;
  String subject;
  TeacherModel({
    required this.id,
    required this.name,
    required this.gmail,
    required this.subject,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'gmail': gmail, 'subject': subject};
  }

  factory TeacherModel.fromModel(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'],
      name: map['name'],
      gmail: map['gmail'],
      subject: map['subject'],
    );
  }
}

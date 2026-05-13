class TeacherModel {
  String? id;
  String name;
  String gmail;
  String? subject;
  String image;
  TeacherModel({
    required this.id,
    required this.name,
    required this.gmail,
    this.subject,
    required this.image,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'gmail': gmail,
      'subject': subject,
    };
  }

  factory TeacherModel.fromModel(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      gmail: map['gmail'],
      subject: map['subject'],
    );
  }
}

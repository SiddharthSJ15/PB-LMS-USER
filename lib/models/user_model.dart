class UserModel {
  int? userId;
  String? name;
  String? email;
  String? role;
  String? phoneNumber;
  String? profilePicture;
  String? registrationId;
  UserModel({
    this.userId,
    this.name,
    this.email,
    this.role,
    this.phoneNumber,
    this.profilePicture,
    this.registrationId,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      registrationId: json['registrationId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'registrationId': registrationId,
    };
  }
}

class CourseModel {
  int? courseId;
  String? courseName;
  String? courseDescription;
  int? batchId;
  String? batchName;
  String? status;

  CourseModel({
    this.courseId,
    this.courseName,
    this.courseDescription,
    this.batchId,
    this.batchName,
    this.status,
  });
  CourseModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseName = json['courseName'];
    courseDescription = json['courseDescription'];
    batchId = json['batchId'];
    batchName = json['batchName'];
    status = json['status'];
  }
}
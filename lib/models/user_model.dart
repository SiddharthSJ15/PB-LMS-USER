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

class ModuleModel {
  int? moduleId;
  String? title;
  String? content;

  ModuleModel({this.moduleId, this.title, this.content});
  ModuleModel.fromJson(Map<String, dynamic> json) {
    moduleId = json['moduleId'];
    title = json['title'];
    content = json['content'];
  }
}

class LessonModel {
  int? lessonId;
  String? title;
  String? content;
  String? videoLink;
  String? pdfPath;
  String? status;
  int? courseId;
  int? moduleId;
  LessonModel({
    this.lessonId,
    this.title,
    this.content,
    this.videoLink,
    this.pdfPath,
    this.status,
    this.courseId,
    this.moduleId,
  });
  LessonModel.fromJson(Map<String, dynamic> json) {
    lessonId = json['lessonId'];
    title = json['title'];
    content = json['content'];
    videoLink = json['videoLink'];
    pdfPath = json['pdfPath'];
    status = json['status'];
    courseId = json['courseId'];
    moduleId = json['moduleId'];
  }
}

class AssignmentModel {
  final int? assignmentId;
  final int? courseId;
  final int? moduleId;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? submissionLink;
  final String? status;

  AssignmentModel({
    this.assignmentId,
    this.courseId,
    this.moduleId,
    required this.title,
    required this.description,
    this.dueDate,
    this.submissionLink,
    required this.status,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      assignmentId: json['assignmentId'],
      courseId: json['courseId'],
      moduleId: json['moduleId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      submissionLink: json['submissionLink'],
      status: json['status'] ?? 'pending',
    );
  }
}

class AttendanceModel {
  int? attendanceId;
  int? studentId;
  int? batchId;
  String? date;
  String? status;
  String? createdDate;
  String? updatedAt;
  AttendanceBatchModel? batch;

  AttendanceModel({
    this.attendanceId,
    this.studentId,
    this.batchId,
    this.date,
    this.status,
    this.createdDate,
    this.updatedAt,
    this.batch,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    attendanceId = json['id'];
    studentId = json['studentId'];
    batchId = json['batchId'];
    date = json['date'];
    status = json['status'];
    createdDate = json['createdAt'];
    updatedAt = json['updatedAt'];
    batch = AttendanceBatchModel.fromJson(json['Batch']);
  }
}

class AttendanceBatchModel {
  String? batchName;
  AttendanceBatchModel({this.batchName});
  AttendanceBatchModel.fromJson(Map<String, dynamic> json) {
    batchName = json['batchName'];
  }
}

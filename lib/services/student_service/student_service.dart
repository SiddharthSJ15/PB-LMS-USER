import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/utilities/token_manager.dart';

class StudentService {
  final baseUrl = 'https://api.portfoliobuilders.in/api';

  Future<Map<String, dynamic>> loginStudentService(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/student/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'status': true,
        'message': 'Login successful',
        'data': responseData['user'],
        'token': responseData['token'],
      };
    } else {
      return {'status': false, 'message': 'Login failed', 'data': null};
    }
  }

  Future<Map<String, dynamic>> getStudentProfileService(
    int studentId,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/getProfile/$studentId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'status': true,
        'message': 'Profile fetched successfully',
        'data': responseData,
      };
    } else {
      return {
        'status': false,
        'message': 'Failed to fetch profile',
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> fetchCourse(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/getStudentCourses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(responseData);
        List<dynamic> body = responseData['courses'];
        List<CourseModel> courses = body
            .map((dynamic item) => CourseModel.fromJson(item))
            .toList();
        return {'courses': courses, 'status': true};
      } else {
        return {'status': false};
      }
    } catch (e) {
      throw Exception('failed to load User Course $e');
    }
  }

  Future<Map<String, dynamic>> fetchCourseModule(
    int? courseId,
    String? token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/getModule/$courseId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> body = responseData['modules'];
        List<ModuleModel> modules = body
            .map((dynamic item) => ModuleModel.fromJson(item))
            .toList();
        return {'data': modules, 'status': true};
      } else {
        return {'status': false, 'message': 'Failed to fetch modules'};
      }
    } catch (e) {
      throw Exception('failed to load Course Modules $e');
    }
  }

  Future<Map<String, dynamic>> getLessonService(
    int? courseId,
    int? moduleId,
    String? token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/getLesson/$courseId/$moduleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> body = responseData['lessons'];
        List<LessonModel> lessons = body
            .map((dynamic item) => LessonModel.fromJson(item))
            .toList();
        return {
          'lessons': lessons,
          'message': responseData['message'],
          'status': true,
        };
      } else {
        return {'message': responseData['message'], 'status': false};
      }
    } catch (e) {
      throw Exception('Error fetching lessons: $e');
    }
  }

  Future<Map<String, dynamic>> getAssignmentService(
    int? courseId,
    int? moduleId,
    String? token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/viewAssignments/$courseId/$moduleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> body = responseData['assignments'];
        List<AssignmentModel> assignments = body
            .map((dynamic item) => AssignmentModel.fromJson(item))
            .toList();
        return {
          'assignments': assignments,
          'message': responseData['message'],
          'status': true,
        };
      } else {
        return {'message': responseData['message'], 'status': false};
      }
    } catch (e) {
      throw Exception('Error fetching assignments: $e');
    }
  }

  Future<Map<String, dynamic>> getAttendanceService(
    int? studentId,
    String? token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/getAttendanceHistory/$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final attendanceCount = responseData['attendanceCount'];
        List<dynamic> body = responseData['attendance'];
        List<AttendanceModel> attendance = body
            .map((dynamic item) => AttendanceModel.fromJson(item))
            .toList();
        return {'attendance': attendance, 'count': attendanceCount, 'status': true};
      } else {
        return {'status': false};
      }
    } catch (e) {
      throw Exception('Error fetching attendance: $e');
    }
  }

  Future<Map<String, dynamic>> markAttendanceService(
    String token,
    String status,
    String date,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/student/markAttendance'),
        body: jsonEncode({'status': status, 'date': date}),
        headers: {
          'Content-Type': 'Application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'status': true};
      } else {
        return {'status': false};
      }
    } catch (e) {
      throw Exception('Error in attendance service');
    }
  }
}

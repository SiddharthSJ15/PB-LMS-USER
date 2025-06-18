import 'package:flutter/material.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/services/student_service/student_service.dart';
import 'package:pb_lms/utilities/token_manager.dart';
import 'package:pb_lms/utilities/user_manager.dart';

class StudentProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _profileLoading = false;
  bool get profileLoading => _profileLoading;

  UserModel _student = UserModel();
  UserModel get student => _student;

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  List<ModuleModel> _modules = [];
  List<ModuleModel> get modules => _modules;

  List<LessonModel> _lessons = [];
  List<LessonModel> get lessons => _lessons;

  List<AssignmentModel> _assignments = [];
  List<AssignmentModel> get assignments => _assignments;

  Future<bool> loginStudentProvider(String email, String password) async {
    _isLoading = true;
    _profileLoading = true;
    notifyListeners();
    try {
      final response = await _studentService.loginStudentService(
        email,
        password,
      );
      if (response['status']) {
        _student = UserModel.fromJson(response['data']);
        await TokenManager.setToken(response['token']);
        await UserManager.setUser(response['data']['userId']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error in loginStudentProvider: $e');
      return false;
    } finally {
      _isLoading = false;
      _profileLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutStudentProvider() async {
    _isLoading = true;
    notifyListeners();
    try {
      await TokenManager.clearToken();
      _student = UserModel();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in logoutStudentProvider: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStudentProfileProvider() async {
    _isLoading = true;
    _profileLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final studentId = await UserManager.getUser();
      print(studentId);
      if (studentId != null && token != null) {
        final response = await _studentService.getStudentProfileService(
          studentId,
          token,
        );
        print(response);
        if (response['status']) {
          _student = UserModel.fromJson(response['data']);
          _isLoading = false;
          _profileLoading = false;
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      } else {
        _isLoading = false;
        _profileLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error in getStudentProfileProvider: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStudentCoursesProvider() async {
    try {
      _isLoading = true;
      notifyListeners();
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await _studentService.fetchCourse(token);

      print(response);
      if (response['status']) {
        _courses = response['courses'];
      } else {
        _courses = [];
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourseModule(int? courseId) async {
    _modules = [];
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final response = await _studentService.fetchCourseModule(courseId, token);
      print(response);
      if (response['status']) {
        _modules = response['data'];
      } else {
        _courses = [];
      }
    } catch (e) {
      throw Exception('Error fetching modules:$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLessons(int? moduleId, int? courseId) async {
    _lessons = [];
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final response = await _studentService.getLessonService(
        courseId,
        moduleId,
        token,
      );
      if (response['status']) {
        _lessons = response['lessons'];
      } else {
        _lessons = [];
      }
    } catch (e) {
      throw Exception('Error in Lessons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAssignments(
    int? moduleId,
    int? courseId,
  ) async {
    _assignments = [];
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _studentService.getAssignmentService(
        courseId,
        moduleId,
      );
      if (response['status']) {
        _assignments = response['assignments'];
      } else {
        _assignments = [];
      }
    } catch (e) {
      throw Exception('Error in Assignments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getAttendance(){
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final token = TokenManager.getToken();
  //     final response = _studentService.getAttendanceService(token);
  //   } catch (e) {
  //     throw Exception('Error in Attendance: $e');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
      
  //   }
  // }

}

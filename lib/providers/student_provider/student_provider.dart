import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
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

  List<AttendanceModel> _attendance = [];
  List<AttendanceModel> get attendance => _attendance;

  Map<String, dynamic>? _live;
  Map<String, dynamic>? get live => _live;

  int? __attendanceCount;
  int? get attendanceCount => __attendanceCount;

  bool? _alreadyMarked;
  bool? get alreadyMarked => _alreadyMarked;

  AssignmentModel? _selectedAssignment;
  AssignmentModel? get selectedAssignment => _selectedAssignment;

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
      await UserManager.clearUser();
      _courses = [];
      _modules = [];
      _lessons = [];
      _assignments = [];
      _attendance = [];
      _live = null;
      _alreadyMarked = null;
      _selectedAssignment = null;
      _isLoading = false;
      _profileLoading = false;
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

  Future<void> getAssignments(int? moduleId, int? courseId) async {
    _assignments = [];
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final response = await _studentService.getAssignmentService(
        courseId,
        moduleId,
        token,
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

  void selectAssignmentById(int? id) {
    try {
      _isLoading = true;
      notifyListeners();
      _selectedAssignment = _assignments.firstWhere(
        (a) => a.assignmentId == id,
      );
      print(_selectedAssignment.toString());
    } catch (e) {
      throw Exception('Error fetching the assignment:$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> submitAssignment(
    String? content,
    String? submissionLink,
    int assignmentId,
  ) async {
    try {
      final token = await TokenManager.getToken();
      final response = await _studentService.submitAssignmentService(
        token,
        assignmentId,
        content,
        submissionLink,
      );
      if (response['status']) {
        getAssignments(
          NavigationProvider().selectedModuleId,
          NavigationProvider().selectedCourseId,
        );
        return {
          'submission': response['submission'],
          'status': true,
          'message': response['message'],
        };
      } else {
        return {'message': response['message'], 'status': false};
      }
    } catch (e) {
      throw Exception('Error submitting assignment');
    }
  }

  Future<Map<String, dynamic>> getSubmittedAssignment(int assignmentId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final token = await TokenManager.getToken();
      final response = await _studentService.getSubmitAssignmentService(
        assignmentId,
        token!,
      );
      if (response['status']) {
        return {
          'submission': response['submission'],
          'status': true,
          'message': response['message'],
        };
      } else {
        return {'message': response['message'], 'status': false};
      }
    } catch (e) {
      print('Error fetching submitted assignment:$e');
      throw Exception('Error in fetching assignment submission');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasMarkedTodayAttendance(List<AttendanceModel> attendanceList) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return attendanceList.any(
      (a) =>
          DateFormat('yyyy-MM-dd').format(DateTime.tryParse(a.createdDate!)!) ==
          today,
    );
  }

  Future<void> getAttendance(
    // int? studentId
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final studentId = await UserManager.getUser();
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await _studentService.getAttendanceService(
        studentId,
        token,
      );
      if (response['status']) {
        __attendanceCount = response['count'];
        _attendance = response['attendance'];
        _alreadyMarked = _attendance.any(
          (values) =>
              DateFormat(
                'yyyy-MM-dd',
              ).format(DateTime.tryParse(values.date!)!) ==
              date,
        );
      } else {
        _attendance = [];
      }
    } catch (e) {
      throw Exception('Error in Attendance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitAttendance(bool status) async {
    try {
      String? value;
      String? date;
      final currentDate = DateTime.now();
      if (status) {
        date = DateFormat('yyyy-MM-dd').format(currentDate);
        value = 'present';
      } else {
        date = DateFormat('yyyy-MM-dd').format(currentDate);
        value = 'absent';
      }
      final token = await TokenManager.getToken();

      final response = await _studentService.markAttendanceService(
        token!,
        value,
        date,
      );
      if (response['status']) {
        getAttendance();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error in attendance provider: $e');
      throw Exception('Error in attendance provider: $e');
    }
  }

  Future<void> getLiveLink(int courseId, int batchId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final response = await _studentService.getLiveLinkService(
        courseId,
        batchId,
        token!,
      );
      if (response['status']) {
        _live = response['data'];
      } else {
        _live = null;
      }
    } catch (e) {
      _live = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

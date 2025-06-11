import 'package:flutter/material.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/services/student_service/student_service.dart';
import 'package:pb_lms/utilities/token_manager.dart';
import 'package:pb_lms/utilities/user_manager.dart';

class StudentProvider with ChangeNotifier {

  final StudentService _studentService = StudentService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserModel _student = UserModel();
  UserModel get student => _student;

  Future<bool> loginStudentProvider(String email, String password) async {
    _isLoading = true;
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
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final studentId = await UserManager.getUser();
      print(studentId);
      if (studentId != null && token != null) {
        final response = await _studentService.getStudentProfileService(studentId,token);
        print(response);
        if (response['status']) {
          _student = UserModel.fromJson(response['data']);
          _isLoading = false;
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error in getStudentProfileProvider: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

}

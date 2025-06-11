import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_lms/models/user_model.dart';

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

  Future<Map<String, dynamic>> getStudentProfileService(int studentId, String token) async {
    final url = Uri.parse('$baseUrl/getProfile/$studentId');
    final response = await http.get(url,headers: {'Content-Type': 'application/json','Authorization':'Bearer $token'});
    if (response.statusCode == 200|| response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'status': true,
        'message': 'Profile fetched successfully',
        'data': responseData,
      };
    } else {
      return {'status': false, 'message': 'Failed to fetch profile', 'data': null};
    }
  }

  Future<Map<String, dynamic>> fetchCourse(int token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getStudentCourses'),
        headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',},
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(responseData);
        List<dynamic> body = responseData['courses'];
        List<CourseModel> courses =
            body.map((dynamic item) => CourseModel.fromJson(item)).toList();
        return {'courses': courses, 'status': true};
      }else{
        return{
          'status': false,
        };
      }
    } catch (e) {
      throw Exception('failed to load User Course $e');
    }
  }

}

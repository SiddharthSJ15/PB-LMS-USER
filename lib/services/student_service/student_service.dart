import 'dart:convert';
import 'package:http/http.dart' as http;

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

}

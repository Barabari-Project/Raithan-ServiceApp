import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final String baseUrl;

  OnboardingRepository({required this.baseUrl});

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> registerMobileNumber(
      String mobileNumber, String path, bool isLogin) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'mobileNumber': "+91$mobileNumber"}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception('User is already in onboarding process');
      } else if (isLogin && response.statusCode == 404) {
        throw Exception('new');
      } else {
        throw Exception('Failed to register mobile number');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
      String mobileNumber, String code, String path) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobileNumber': "+91$mobileNumber",
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        if (token != null) {
          await _saveToken(token);
        }
        return responseData;
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>?> uploadProfile({
    required File image,
    required String firstName,
    required String lastName,
    required String year,
    required String gender,
  }) async {
    final url = Uri.parse(
        '$baseUrl/raithan/api/service-providers/onboard/user/profile');
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Auth token not found');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['yearOfBirth'] = year;
      request.fields['gender'] = gender;
      var imageFile = await http.MultipartFile.fromPath('img', image.path);
      request.files.add(imageFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}

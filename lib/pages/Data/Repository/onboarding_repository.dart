import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';

class OnboardingRepository {
  final String baseUrl;

  OnboardingRepository({required this.baseUrl});

  Future<Map<String, dynamic>> registerMobileNumber(String mobileNumber,
      String path, bool isLogin, BuildContext context) async {
    final url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'mobileNumber': "+91$mobileNumber"}),
      );

      final responsBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responsBody;
      } else {
        throw Exception(responsBody["error"]);
      }
    } catch (e) {
      print(e);
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
        // if (token != null) {
        //   await _saveToken(token);
        // }
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
      print("here");
      final token = await Storage.getValue(StorageKeys.JWT_TOKEN);
      print(token);

      var request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['yearOfBirth'] = year;
      request.fields['gender'] = gender;

      List<String> imagePart = image.path.split(".");
      var extension = imagePart.last;
      print(extension);

      var imageFile = await http.MultipartFile.fromPath('img', image.path,
          contentType: MediaType('image', extension));
      request.files.add(imageFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("Here is the value");
        print(value);
      });
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}

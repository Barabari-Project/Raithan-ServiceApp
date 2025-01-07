import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';

import '../dtos/file_with_media_type.dart';
import 'BaseApiServices.dart';
import 'app_exception.dart';

class NetworkApiService extends BaseApiServices {
  Future<Map<String, String>?> _addJWTToken(
      Map<String, String>? headers, bool authenticationRequired) async {
    if (!authenticationRequired) {
      return headers;
    }

    String? jwtToken = await Storage.getValue("jwtToken");

    if (headers != null) {
      headers['Authorization'] = 'Baerer $jwtToken';
      return headers;
    }

    Map<String, String> authHeader = HashMap();
    authHeader['Authorization'] = 'Baerer $jwtToken';
    return authHeader;
  }

  @override
  Future getGetApiResponse(String url, Map<String, String>? headers,
      bool authenticationRequired) async {
    dynamic responsejson;

    try {
      final response = await http
          .get(Uri.parse(url),
              headers: await _addJWTToken(headers, authenticationRequired))
          .timeout(Duration(seconds: 10));
      responsejson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }

    return responsejson;
  }

  @override
  Future getPostApiResponse(String url, Map<String, String>? headers,
      Object? body, Encoding? encoding, bool authenticationRequired) async {
    dynamic responsejson;

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: await _addJWTToken(headers, authenticationRequired),
              body: body,
              encoding: encoding)
          .timeout(Duration(seconds: 10));
      responsejson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responsejson;
  }

  @override
  Future<Map<String, dynamic>?> postMultipartFilesUploadApiResponse(
      String url,
      Map<String, String>? headers,
      Map<String, String> fields,
      Map<String, FileWithMediaType> files,
      bool authenticationRequired) async {
    dynamic responseJson;

    try {
      headers = await _addJWTToken(headers, authenticationRequired);

      var request = http.MultipartRequest(
          'POST', Uri.parse("${APIConstants.baseUrl}${url}"));

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Handle multiple files
      files.forEach((filename, fileWithMediaType) async {

        var fileToUpload = await http.MultipartFile.fromPath(
            filename, fileWithMediaType.file.path,
            contentType: fileWithMediaType.mediaType);

        request.files.add(fileToUpload);

      });

      // Send the request
      http.StreamedResponse response = await request.send();

      responseJson = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 401) {
        throw UnAuthorizedException();
      } else if (response.statusCode == 200) {
        return responseJson;
      } else {
        BadRequestException(responseJson["error"]);
      }
    } catch (e) {
      throw Exception(e);
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 401:
        throw UnAuthorizedException();
      default:
        throw BadRequestException(jsonDecode(response.body)["error"]);
    }
  }
}

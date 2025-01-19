import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/api_constants.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';

import '../dtos/file_with_media_type.dart';
import 'BaseApiServices.dart';
import 'app_exception.dart';

class NetworkApiService extends BaseApiServices {
  Future<Map<String, String>?> _addJWTToken(
      Map<String, String>? headers, bool authenticationRequired) async {
    if (!authenticationRequired) {
      return headers;
    }

    String? jwtToken = await Storage.getValue(StorageKeys.JWT_TOKEN);

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

  Future<dynamic> getPutApiResponse(String url, Map<String, String>? headers, Object? body, Encoding? encoding, bool authenticationRequired) async
  {

    dynamic responsejson;

    try {
      final response = await http
          .put(Uri.parse(url),
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
      Map<String, FileWithMediaType>? files,
      bool authenticationRequired, {String requestType = 'POST'}) async {
    dynamic responseJson;

    try {
      headers = await _addJWTToken(headers, authenticationRequired);

      var request = http.MultipartRequest(
          requestType, Uri.parse("${APIConstants.baseUrl}${url}"));

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      if(files != null) {
        // Handle multiple files
        files.forEach((filename, fileWithMediaType) async {
          var fileToUpload = await http.MultipartFile.fromPath(
              filename, fileWithMediaType.file.path,
              contentType: fileWithMediaType.mediaType);

          request.files.add(fileToUpload);
        });
      }

      // Send the request
      http.StreamedResponse response = await request.send();

      responseJson = jsonDecode(await response.stream.bytesToString());


      if (response.statusCode == 401) {
        throw UnAuthorizedException();
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        return responseJson;
      } else {
        if(responseJson.containsKey('error'))
          {
           throw BadRequestException(responseJson['error']);
          }
        else{
          throw BadRequestException(responseJson["error"]);
        }
      }
    } catch (e) {
      throw Exception(e);
    }

  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? jsonDecode(response.body) : {} ;
      case 201:
        return response.body.isNotEmpty ? jsonDecode(response.body) : {} ;
      case 204:
        return null;
      case 401:
        throw UnAuthorizedException();
      case 502:
        throw BadRequestException("Server Is Down, Please Try Again Later");
      default:
        throw BadRequestException(jsonDecode(response.body)["error"]);
    }
  }
}

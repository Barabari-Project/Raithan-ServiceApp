import 'dart:convert';
import 'dart:io';

import '../dtos/file_with_media_type.dart';

abstract class BaseApiServices{

  Future<dynamic> getGetApiResponse(String url, Map<String, String>? headers, bool authenticationRequired);

  Future<dynamic> getPostApiResponse(String url, Map<String, String>? headers, Object? body, Encoding? encoding, bool authenticationRequired);

  Future<Map<String, dynamic>?> postMultipartFilesUploadApiResponse(
      String url,
      Map<String, String>? headers,
      Map<String, String> fields,
      Map<String, FileWithMediaType> files,
      bool authenticationRequired
      );
}
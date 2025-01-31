import 'dart:io';
import 'package:http_parser/src/media_type.dart';

class FileWithMediaType {

  final File file;
  final MediaType mediaType;
  FileWithMediaType(this.file, this.mediaType);

}
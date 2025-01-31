
class AppException implements Exception{
  final _message;

  const AppException([this._message]);

  @override
  String toString()
  {
    return '$_message';
  }
}

class FetchDataException extends AppException{
  FetchDataException([String ? super.message]);
}

class BadRequestException extends AppException{
  BadRequestException([String ? super.message]);
}

class UnAuthorizedException extends AppException{
  UnAuthorizedException([String ? super.message]);
}


class InvalidInputException extends AppException{
  InvalidInputException([String ? super.message]);
}

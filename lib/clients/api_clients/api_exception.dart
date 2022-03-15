class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([message]) : super(message, "");
}

class ServerError extends ApiException {
  ServerError([message]) : super(message, "");
}

class InvalidUser extends ApiException {
  InvalidUser([message]) : super(message, "Invalid User name or password");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException([message]) : super(message, "");
}

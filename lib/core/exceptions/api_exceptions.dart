class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException({required this.message, this.statusCode, this.details});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException({String? message})
    : super(message: message ?? 'Erro de conexão. Verifique sua internet.');
}

class ServerException extends ApiException {
  ServerException({String? message, super.statusCode, super.details})
    : super(message: message ?? 'Erro no servidor');
}

class ValidationException extends ApiException {
  ValidationException({String? message, super.details})
    : super(message: message ?? 'Erro de validação', statusCode: 400);
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
    : super(message: message ?? 'Recurso não encontrado', statusCode: 404);
}

class ConflictException extends ApiException {
  ConflictException({String? message})
    : super(message: message ?? 'Conflito: recurso já existe', statusCode: 409);
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  
  const ServerException({
    required this.message,
    this.statusCode,
    this.code,
  });
  
  @override
  String toString() => 'ServerException: $message (code: $code, status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException({required this.message});
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  
  const CacheException({required this.message});
  
  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;
  
  const ValidationException({
    required this.message,
    this.errors,
  });
  
  @override
  String toString() => 'ValidationException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AuthException: $message (code: $code)';
}

class PermissionException implements Exception {
  final String message;
  final String? permission;
  
  const PermissionException({
    required this.message,
    this.permission,
  });
  
  @override
  String toString() => 'PermissionException: $message (permission: $permission)';
}

class NotFoundException implements Exception {
  final String message;
  final String? resource;
  
  const NotFoundException({
    required this.message,
    this.resource,
  });
  
  @override
  String toString() => 'NotFoundException: $message (resource: $resource)';
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
    String? code,
  }) = ServerFailure;
  
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;
  
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;
  
  const factory Failure.validation({
    required String message,
    Map<String, List<String>>? errors,
  }) = ValidationFailure;
  
  const factory Failure.auth({
    required String message,
    String? code,
  }) = AuthFailure;
  
  const factory Failure.permission({
    required String message,
    String? permission,
  }) = PermissionFailure;
  
  const factory Failure.notFound({
    required String message,
    String? resource,
  }) = NotFoundFailure;
  
  const factory Failure.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}

extension FailureExtension on Failure {
  String get userMessage => when(
    server: (message, _, __) => message,
    network: (message) => message,
    cache: (message) => message,
    validation: (message, _) => message,
    auth: (message, _) => message,
    permission: (message, _) => message,
    notFound: (message, _) => message,
    unknown: (message, _, __) => message,
  );
  
  bool get isAuthFailure => this is AuthFailure;
  bool get isNetworkFailure => this is NetworkFailure;
  bool get isValidationFailure => this is ValidationFailure;
}
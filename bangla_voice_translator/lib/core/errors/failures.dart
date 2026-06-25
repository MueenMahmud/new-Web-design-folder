import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class AudioFailure extends Failure {
  const AudioFailure({required super.message});
}

class TranslationFailure extends Failure {
  const TranslationFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied'});
}

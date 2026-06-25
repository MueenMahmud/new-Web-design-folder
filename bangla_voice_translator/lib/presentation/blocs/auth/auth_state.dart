import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile? user;
  final String? errorMessage;
  final bool isGuest;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isGuest = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? errorMessage,
    bool? isGuest,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isGuest];
}

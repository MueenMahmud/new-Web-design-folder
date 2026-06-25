import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/typedef.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInAsGuest signInAsGuest;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final ResetPassword resetPassword;

  AuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signInWithGoogle,
    required this.signInAsGuest,
    required this.signOut,
    required this.getCurrentUser,
    required this.resetPassword,
  }) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInWithEmailRequested>(_onSignInEmail);
    on<SignUpWithEmailRequested>(_onSignUpEmail);
    on<SignInWithGoogleRequested>(_onSignInGoogle);
    on<SignInAsGuestRequested>(_onSignInGuest);
    on<SignOutRequested>(_onSignOut);
    on<ResetPasswordRequested>(_onResetPassword);
  }

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await getCurrentUser();
    if (result.isSuccess && result.data != null) {
      final user = result.data!;
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isGuest: user.isGuest,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onSignInEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signInWithEmail(
      email: event.email,
      password: event.password,
    );
    result.fold(
      onSuccess: (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onSignUpEmail(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );
    result.fold(
      onSuccess: (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onSignInGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signInWithGoogle();
    result.fold(
      onSuccess: (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onSignInGuest(
    SignInAsGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signInAsGuest();
    result.fold(
      onSuccess: (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isGuest: true,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onResetPassword(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    await resetPassword(event.email);
  }
}

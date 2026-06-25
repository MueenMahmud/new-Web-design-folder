import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../../core/utils/typedef.dart';

class SignInWithEmail {
  final AuthRepository repository;

  const SignInWithEmail(this.repository);

  ResultFuture<UserProfile> call({
    required String email,
    required String password,
  }) {
    return repository.signInWithEmail(email: email, password: password);
  }
}

class SignUpWithEmail {
  final AuthRepository repository;

  const SignUpWithEmail(this.repository);

  ResultFuture<UserProfile> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}

class SignInWithGoogle {
  final AuthRepository repository;

  const SignInWithGoogle(this.repository);

  ResultFuture<UserProfile> call() {
    return repository.signInWithGoogle();
  }
}

class SignInAsGuest {
  final AuthRepository repository;

  const SignInAsGuest(this.repository);

  ResultFuture<UserProfile> call() {
    return repository.signInAsGuest();
  }
}

class SignOut {
  final AuthRepository repository;

  const SignOut(this.repository);

  ResultVoid call() {
    return repository.signOut();
  }
}

class GetCurrentUser {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  ResultFuture<UserProfile?> call() {
    return repository.getCurrentUser();
  }
}

class ResetPassword {
  final AuthRepository repository;

  const ResetPassword(this.repository);

  ResultVoid call(String email) {
    return repository.resetPassword(email);
  }
}

import '../entities/user_profile.dart';
import '../../core/utils/typedef.dart';

abstract class AuthRepository {
  Stream<UserProfile?> get authStateChanges;

  ResultFuture<UserProfile> signInWithEmail({
    required String email,
    required String password,
  });

  ResultFuture<UserProfile> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  ResultFuture<UserProfile> signInWithGoogle();

  ResultFuture<UserProfile> signInAsGuest();

  ResultVoid signOut();

  ResultFuture<UserProfile?> getCurrentUser();

  ResultVoid resetPassword(String email);

  ResultVoid updateProfile({String? displayName, String? photoUrl});
}

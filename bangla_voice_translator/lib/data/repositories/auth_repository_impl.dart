import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/typedef.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseRemoteSource remoteSource;

  AuthRepositoryImpl({required this.remoteSource});

  @override
  Stream<UserProfile?> get authStateChanges {
    return remoteSource.authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      return remoteSource.getCurrentUser();
    });
  }

  @override
  ResultFuture<UserProfile> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteSource.signInWithEmail(email, password);
      return (data: user as UserProfile, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultFuture<UserProfile> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final user =
          await remoteSource.signUpWithEmail(email, password, displayName);
      return (data: user as UserProfile, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultFuture<UserProfile> signInWithGoogle() async {
    // Google Sign-In requires platform-specific setup
    return (
      data: null,
      failure: const AuthFailure(message: 'Google Sign-In not configured yet')
    );
  }

  @override
  ResultFuture<UserProfile> signInAsGuest() async {
    try {
      final user = await remoteSource.signInAsGuest();
      return (data: user as UserProfile, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await remoteSource.signOut();
      return (data: null, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultFuture<UserProfile?> getCurrentUser() async {
    try {
      final user = await remoteSource.getCurrentUser();
      return (data: user, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultVoid resetPassword(String email) async {
    try {
      await remoteSource.resetPassword(email);
      return (data: null, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }

  @override
  ResultVoid updateProfile({String? displayName, String? photoUrl}) async {
    try {
      await remoteSource.updateProfile(
          displayName: displayName, photoUrl: photoUrl);
      return (data: null, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: AuthFailure(message: e.message));
    }
  }
}

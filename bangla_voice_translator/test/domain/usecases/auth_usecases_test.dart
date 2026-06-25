import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/core/errors/failures.dart';
import 'package:bangla_voice_translator/core/utils/typedef.dart';
import 'package:bangla_voice_translator/domain/entities/user_profile.dart';
import 'package:bangla_voice_translator/domain/repositories/auth_repository.dart';
import 'package:bangla_voice_translator/domain/usecases/auth_usecases.dart';

class FakeAuthRepository implements AuthRepository {
  ({UserProfile? data, Failure? failure})? signInResult;
  ({UserProfile? data, Failure? failure})? signUpResult;
  ({UserProfile? data, Failure? failure})? guestResult;
  ({void data, Failure? failure})? signOutResult;
  ({UserProfile? data, Failure? failure})? currentUserResult;
  ({void data, Failure? failure})? resetPasswordResult;
  ({UserProfile? data, Failure? failure})? googleResult;
  ({void data, Failure? failure})? updateProfileResult;

  @override
  Stream<UserProfile?> get authStateChanges => const Stream.empty();

  @override
  ResultFuture<UserProfile> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return signInResult!;
  }

  @override
  ResultFuture<UserProfile> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return signUpResult!;
  }

  @override
  ResultFuture<UserProfile> signInWithGoogle() async {
    return googleResult!;
  }

  @override
  ResultFuture<UserProfile> signInAsGuest() async {
    return guestResult!;
  }

  @override
  ResultVoid signOut() async {
    return signOutResult!;
  }

  @override
  ResultFuture<UserProfile?> getCurrentUser() async {
    return currentUserResult!;
  }

  @override
  ResultVoid resetPassword(String email) async {
    return resetPasswordResult!;
  }

  @override
  ResultVoid updateProfile({String? displayName, String? photoUrl}) async {
    return updateProfileResult!;
  }
}

void main() {
  late FakeAuthRepository fakeRepository;

  final tUser = UserProfile(
    uid: 'test-uid',
    displayName: 'Test User',
    email: 'test@test.com',
    createdAt: DateTime(2024, 1, 1),
  );

  final tGuestUser = UserProfile(
    uid: 'guest-uid',
    isGuest: true,
    createdAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    fakeRepository = FakeAuthRepository();
  });

  group('SignInWithEmail', () {
    test('should return UserProfile on success', () async {
      fakeRepository.signInResult = (data: tUser, failure: null);
      final usecase = SignInWithEmail(fakeRepository);

      final result = await usecase(
        email: 'test@test.com',
        password: 'password',
      );

      expect(result.isSuccess, true);
      expect(result.data, tUser);
    });

    test('should return failure on invalid credentials', () async {
      fakeRepository.signInResult = (
        data: null,
        failure: const AuthFailure(message: 'Invalid credentials'),
      );
      final usecase = SignInWithEmail(fakeRepository);

      final result = await usecase(
        email: 'test@test.com',
        password: 'wrong',
      );

      expect(result.isFailure, true);
    });
  });

  group('SignUpWithEmail', () {
    test('should return UserProfile on success', () async {
      fakeRepository.signUpResult = (data: tUser, failure: null);
      final usecase = SignUpWithEmail(fakeRepository);

      final result = await usecase(
        email: 'test@test.com',
        password: 'password',
        displayName: 'Test User',
      );

      expect(result.isSuccess, true);
      expect(result.data, tUser);
    });
  });

  group('SignInAsGuest', () {
    test('should return guest UserProfile', () async {
      fakeRepository.guestResult = (data: tGuestUser, failure: null);
      final usecase = SignInAsGuest(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data?.isGuest, true);
    });
  });

  group('SignOut', () {
    test('should return success', () async {
      fakeRepository.signOutResult = (data: null, failure: null);
      final usecase = SignOut(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
    });
  });

  group('GetCurrentUser', () {
    test('should return UserProfile when logged in', () async {
      fakeRepository.currentUserResult = (data: tUser, failure: null);
      final usecase = GetCurrentUser(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data, tUser);
    });

    test('should return null when not logged in', () async {
      fakeRepository.currentUserResult = (data: null, failure: null);
      final usecase = GetCurrentUser(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data, isNull);
    });
  });

  group('ResetPassword', () {
    test('should return success', () async {
      fakeRepository.resetPasswordResult = (data: null, failure: null);
      final usecase = ResetPassword(fakeRepository);

      final result = await usecase('test@test.com');

      expect(result.isSuccess, true);
    });
  });
}

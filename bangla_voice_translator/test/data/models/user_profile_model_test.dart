import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/data/models/user_profile_model.dart';
import 'package:bangla_voice_translator/domain/entities/user_profile.dart';

void main() {
  final tModel = UserProfileModel(
    uid: 'test-uid',
    displayName: 'Test User',
    email: 'test@test.com',
    photoUrl: null,
    isGuest: false,
    createdAt: DateTime(2024, 1, 1),
    lastLoginAt: DateTime(2024, 6, 1),
  );

  final tJson = {
    'uid': 'test-uid',
    'displayName': 'Test User',
    'email': 'test@test.com',
    'photoUrl': null,
    'isGuest': false,
    'createdAt': '2024-01-01T00:00:00.000',
    'lastLoginAt': '2024-06-01T00:00:00.000',
  };

  group('UserProfileModel', () {
    test('should be a subclass of UserProfile entity', () {
      expect(tModel, isA<UserProfile>());
    });

    test('should create model from JSON', () {
      final result = UserProfileModel.fromJson(tJson);

      expect(result.uid, tModel.uid);
      expect(result.displayName, tModel.displayName);
      expect(result.email, tModel.email);
      expect(result.isGuest, tModel.isGuest);
    });

    test('should convert model to JSON', () {
      final result = tModel.toJson();

      expect(result['uid'], tJson['uid']);
      expect(result['displayName'], tJson['displayName']);
      expect(result['email'], tJson['email']);
      expect(result['isGuest'], tJson['isGuest']);
    });

    test('should create model from entity', () {
      final entity = UserProfile(
        uid: 'test-uid',
        displayName: 'Test User',
        email: 'test@test.com',
        createdAt: DateTime(2024, 1, 1),
      );

      final result = UserProfileModel.fromEntity(entity);

      expect(result.uid, entity.uid);
      expect(result.displayName, entity.displayName);
    });

    test('should handle guest profile', () {
      final guestJson = {
        'uid': 'guest-uid',
        'displayName': 'Guest',
        'email': null,
        'photoUrl': null,
        'isGuest': true,
        'createdAt': '2024-01-01T00:00:00.000',
        'lastLoginAt': null,
      };

      final result = UserProfileModel.fromJson(guestJson);

      expect(result.isGuest, true);
      expect(result.email, null);
      expect(result.lastLoginAt, null);
    });
  });
}

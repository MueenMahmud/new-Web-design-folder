import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/translation_model.dart';
import '../../models/user_profile_model.dart';

abstract class FirebaseRemoteSource {
  Stream<User?> get authStateChanges;

  Future<UserProfileModel> signInWithEmail(String email, String password);

  Future<UserProfileModel> signUpWithEmail(
      String email, String password, String displayName);

  Future<UserProfileModel> signInAsGuest();

  Future<void> signOut();

  Future<UserProfileModel?> getCurrentUser();

  Future<void> resetPassword(String email);

  Future<void> updateProfile({String? displayName, String? photoUrl});

  Future<void> saveTranslation(TranslationModel translation);

  Future<List<TranslationModel>> getTranslations(String userId);

  Future<void> deleteTranslation(String userId, String translationId);

  Future<void> saveFavorite(String userId, TranslationModel translation);

  Future<List<TranslationModel>> getFavorites(String userId);

  Future<void> removeFavorite(String userId, String translationId);

  Future<void> saveUserProfile(UserProfileModel profile);
}

class FirebaseRemoteSourceImpl implements FirebaseRemoteSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteSourceImpl({required this.auth, required this.firestore});

  @override
  Stream<User?> get authStateChanges => auth.authStateChanges();

  @override
  Future<UserProfileModel> signInWithEmail(
      String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userToProfile(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserProfileModel> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      final profile = _userToProfile(credential.user!).copyWith(
        displayName: displayName,
      );
      await saveUserProfile(UserProfileModel.fromEntity(profile));
      return UserProfileModel.fromEntity(profile);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Registration failed');
    }
  }

  @override
  Future<UserProfileModel> signInAsGuest() async {
    try {
      final credential = await auth.signInAnonymously();
      final profile = UserProfileModel(
        uid: credential.user!.uid,
        isGuest: true,
        createdAt: DateTime.now(),
        displayName: 'Guest',
      );
      await saveUserProfile(profile);
      return profile;
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Guest sign-in failed');
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<UserProfileModel?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;
    return _userToProfile(user);
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Password reset failed');
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw const ServerException(message: 'No user signed in');
      }
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Profile update failed');
    }
  }

  @override
  Future<void> saveTranslation(TranslationModel translation) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.translationsCollection)
          .doc(translation.id)
          .set(translation.toJson());
    } catch (e) {
      throw ServerException(message: 'Failed to save translation: $e');
    }
  }

  @override
  Future<List<TranslationModel>> getTranslations(String userId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.translationsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TranslationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get translations: $e');
    }
  }

  @override
  Future<void> deleteTranslation(String userId, String translationId) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.translationsCollection)
          .doc(translationId)
          .delete();
    } catch (e) {
      throw ServerException(message: 'Failed to delete translation: $e');
    }
  }

  @override
  Future<void> saveFavorite(String userId, TranslationModel translation) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.favoritesCollection)
          .doc(translation.id)
          .set(translation.toJson());
    } catch (e) {
      throw ServerException(message: 'Failed to save favorite: $e');
    }
  }

  @override
  Future<List<TranslationModel>> getFavorites(String userId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.favoritesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TranslationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get favorites: $e');
    }
  }

  @override
  Future<void> removeFavorite(String userId, String translationId) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.favoritesCollection)
          .doc(translationId)
          .delete();
    } catch (e) {
      throw ServerException(message: 'Failed to remove favorite: $e');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException(message: 'Failed to save user profile: $e');
    }
  }

  UserProfileModel _userToProfile(User user) {
    return UserProfileModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      isGuest: user.isAnonymous,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }
}

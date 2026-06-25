import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.isGuest = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoUrl,
        isGuest,
        createdAt,
        lastLoginAt,
      ];
}

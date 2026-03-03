import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final int cvCount;
  final String subscription;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.role = 'user',
    this.isActive = true,
    required this.createdAt,
    required this.lastLoginAt,
    this.cvCount = 0,
    this.subscription = 'free',
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        role,
        isActive,
        createdAt,
        lastLoginAt,
        cvCount,
        subscription,
      ];

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? cvCount,
    String? subscription,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      cvCount: cvCount ?? this.cvCount,
      subscription: subscription ?? this.subscription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'cvCount': cvCount,
      'subscription': subscription,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
      role: map['role'] ?? 'user',
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      lastLoginAt: DateTime.parse(map['lastLoginAt']),
      cvCount: map['cvCount'] ?? 0,
      subscription: map['subscription'] ?? 'free',
    );
  }

  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  bool get isPremium => subscription == 'premium';
  bool get isRecent {
    final now = DateTime.now();
    return now.difference(lastLoginAt).inDays <= 7;
  }
}

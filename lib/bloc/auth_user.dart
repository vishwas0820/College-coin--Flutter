import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable 
class AuthUser {
  final String? email;
  final bool isEmailverified;
  final String id;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailverified
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(id: user.uid, email: user.email, isEmailverified: user.emailVerified);
  
}
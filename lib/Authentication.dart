import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<User?> SignIn(String email, String password);
  Future<User?> SignUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> SignIn(String email, String password) async {
    UserCredential userCred = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password));
    return userCred.user;
  }
  Future<User?> SignUp(String email, String password) async {
    UserCredential userCred = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password));
    return userCred.user;
  }

  Future<String> getCurrentUser() async {
    User user = (await _firebaseAuth.currentUser) as User;
    return user.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}

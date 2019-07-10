import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // signin method definition
  Future<String> signin(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user.uid;
  }

  // signup method definition
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Stream<FirebaseUser> authState$() {
    return _firebaseAuth.onAuthStateChanged;
  }
}

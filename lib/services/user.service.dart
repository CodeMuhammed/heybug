import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heybug/models/index.dart';

import './firestore.service.dart';

class UserService {
  FirestoreService _firestoreService = new FirestoreService();

  Future<DocumentReference> addUser(User user) {
    return _firestoreService.addDoc('/users', user.toJSon());
  }

  Future<void> updateUser(User user) {
    return _firestoreService.updateDoc('/users/${user.id}', user.toJSon());
  }

  Stream<List<User>> getAllUsers() {
    StreamController<List<User>> streamController = new StreamController();

    _firestoreService.$colWithIds('/users', (ref) => ref).listen((docs) {
      streamController.add(
        docs.map((doc) => User.fromJson(doc)).toList(),
      );
    });

    return streamController.stream;
  }

  Future<User> getUserByEmail(String email) {
    Completer<User> userFuture = new Completer();
    _firestoreService
        .$colWithIds('/users', (ref) => ref)
        .take(1)
        .listen((docs) {
      List<User> users = docs.map((doc) => User.fromJson(doc)).toList();
      userFuture.complete(users[0]);
    });

    return userFuture.future;
  }
}

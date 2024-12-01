import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../databases/user.dart';
import '../models/user.dart';

abstract class IUserService {
  Stream<UserModel> get onUserChanged;

  Future<void> signIn(String email, String password);

  Future<void> signOut();

  Future<void> refreshCurrentUserInstance();

  Future<void> updateFieldInFireStore(Map<String, dynamic> fieldsNewValues);

  Future<void> update(Map<String, dynamic> data);

  Future<void> delete();

  // Add currentUser getter
  Future<UserModel?> get currentUser;
}

class UserService implements IUserService {
  static final UserService _instance = UserService._internal();

  // Factory constructor
  factory UserService() {
    return _instance;
  }

  // Private constructor
  UserService._internal();

  // Stream controller for user changes
  final StreamController<UserModel> _userChangeController =
      StreamController<UserModel>.broadcast();

  // Current user instance
  UserModel? _currentUser;

  // Expose the user change stream
  @override
  Stream<UserModel> get onUserChanged => _userChangeController.stream;

  // Getter for currentUser that returns a Future
  @override
  Future<UserModel?> get currentUser async {
    if (_currentUser != null) {
      return _currentUser;
    } else {
      await _initializeCurrentUser();
      return _currentUser;
    }
  }

  // Private method to initialize the current user
  Future<void> _initializeCurrentUser() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      Map<String, dynamic>? data;
      List<String> channels = [];

      if (firebaseUser != null) {
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userData.exists) {
          data = userData.data()!;
        }
      }

      // Fetch cartProducts and orders from local database
      String userID = firebaseUser?.uid ?? 'GUEST';

      _currentUser = UserModel(
        uID: userID,
        email: data?['email'],
        password: data?['password'],
        channels: channels,
      );

      _userChangeController.add(_currentUser!);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing current user: $e');
      }
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Get the current user's ID after signing in
      String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserID != null) {
        await UserDatabaseProvider()
            .updateGuestUserIDToCurrentUser(currentUserID);
      }

      await refreshCurrentUserInstance();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await refreshCurrentUserInstance();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> refreshCurrentUserInstance() async {
    try {
      _currentUser = null;
      await _initializeCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateFieldInFireStore(Map<String, dynamic> fieldsNewValues) async {
    UserModel? user = await currentUser;

    if (user == null || user.uID == 'GUEST') return;

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try {
      await fireStore.collection('users').doc(user.uID).update(fieldsNewValues);
      _userChangeController.add(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(Map<String, dynamic> data) async {
    UserModel? user = await currentUser;

    if (user == null) {
      throw Exception("User not initialized");
    }

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try {
      await fireStore.collection('users').doc(user.uID).update(data);
      _userChangeController.add(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> delete() async {
    UserModel? user = await currentUser;

    if (user == null) {
      throw Exception("User not initialized");
    }

    try {
      String uID = user.uID;

      // Delete user's account from Firebase Authentication
      await FirebaseAuth.instance.currentUser?.delete();

      // Delete user's document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uID).delete();

      await UserDatabaseProvider().deleteUserData(uID);

      // Clear the current user instance
      await refreshCurrentUserInstance();
    } catch (e) {
      rethrow;
    }
  }
}

// Create this file at:
// lib/providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:torva/models/user.dart';
import 'package:torva/Services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  final UserService _userService = UserService();
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Initialize the provider and load user data
  Future<void> initialize() async {
    await refreshUser();
  }

  // Refresh user data from Firestore
  Future<void> refreshUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      
      if (firebaseUser != null) {
        _currentUser = await _userService.getUserByEmail(firebaseUser.email!);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile data
  Future<void> updateUserProfile({
    String? username,
    String? photoURL,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      UserModel updatedUser = _currentUser!.copyWith(
        username: username ?? _currentUser!.username,
        photoURL: photoURL ?? _currentUser!.photoURL,
      );

      await _userService.updateUser(updatedUser);

      // Update local user data
      _currentUser = updatedUser;
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear user data on logout
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
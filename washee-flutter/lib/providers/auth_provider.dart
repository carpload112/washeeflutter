import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:washee/models/user.dart' as app_user;

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _error;

  app_user.User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        _currentUser = app_user.User(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
        );
      } else {
        // User document doesn't exist yet, might be a new user
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
          _currentUser = app_user.User(
            id: uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            phone: firebaseUser.phoneNumber ?? '',
          );
          
          // Create the user document
          await _firestore.collection('users').doc(uid).set({
            'name': _currentUser!.name,
            'email': _currentUser!.email,
            'phone': _currentUser!.phone,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    // Firebase Auth will automatically handle the auth state
    final user = _auth.currentUser;
    if (user != null) {
      await _fetchUserData(user.uid);
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await _fetchUserData(userCredential.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      _error = 'Unknown error occurred';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = _handleAuthError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        // Create user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        _currentUser = app_user.User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
        );
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      _error = 'Unknown error occurred';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = _handleAuthError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name, String email, String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        _error = 'User not authenticated';
        notifyListeners();
        return false;
      }
      
      // Update email if changed
      if (user.email != email) {
        await user.updateEmail(email);
      }
      
      // Update display name
      await user.updateDisplayName(name);
      
      // Update user document in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      _currentUser = app_user.User(
        id: user.uid,
        name: name,
        email: email,
        phone: phone,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _handleAuthError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _handleAuthError(e);
      notifyListeners();
      return false;
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The email address is already in use.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'requires-recent-login':
          return 'Please log in again before retrying this request.';
        default:
          return error.message ?? 'An unknown error occurred.';
      }
    }
    return error.toString();
  }
}


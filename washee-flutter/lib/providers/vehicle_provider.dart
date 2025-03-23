import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:washee/models/vehicle.dart';
import 'package:washee/services/storage_service.dart';

class VehicleProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final StorageService _storageService = StorageService();
  
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  VehicleProvider() {
    _initVehiclesListener();
  }

  void _initVehiclesListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToUserVehicles(user.uid);
      } else {
        _vehicles = [];
        notifyListeners();
      }
    });
  }

  void _listenToUserVehicles(String userId) {
    _database.child('vehicles').orderByChild('userId').equalTo(userId).onValue.listen((event) {
      _vehicles = [];
      
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        
        data.forEach((key, value) {
          final vehicle = _parseVehicle(key.toString(), value as Map<dynamic, dynamic>);
          _vehicles.add(vehicle);
        });
      }
      
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      notifyListeners();
    });
  }

  Vehicle _parseVehicle(String id, Map<dynamic, dynamic> data) {
    return Vehicle(
      id: id,
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? '',
      licensePlate: data['licensePlate'] ?? '',
      color: data['color'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Future<void> addVehicle(String make, String model, String year, String licensePlate, String color, File? image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }
      
      final newVehicleRef = _database.child('vehicles').push();
      String? imageUrl;
      
      if (image != null) {
        imageUrl = await _storageService.uploadVehicleImage(user.uid, newVehicleRef.key!, image);
      }
      
      await newVehicleRef.set({
        'userId': user.uid,
        'make': make,
        'model': model,
        'year': year,
        'licensePlate': licensePlate,
        'color': color,
        'imageUrl': imageUrl,
        'createdAt': ServerValue.timestamp,
      });
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateVehicle(String id, String make, String model, String year, String licensePlate, String color, File? image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }
      
      final updates = {
        'make': make,
        'model': model,
        'year': year,
        'licensePlate': licensePlate,
        'color': color,
        'updatedAt': ServerValue.timestamp,
      };
      
      if (image != null) {
        final imageUrl = await _storageService.uploadVehicleImage(user.uid, id, image);
        updates['imageUrl'] = imageUrl;
      }
      
      await _database.child('vehicles').child(id).update(updates);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }
      
      // Delete vehicle image from storage
      await _storageService.deleteVehicleImage(user.uid, id);
      
      // Delete vehicle from database
      await _database.child('vehicles').child(id).remove();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}


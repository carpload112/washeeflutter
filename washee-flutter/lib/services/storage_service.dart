import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<String> uploadVehicleImage(String userId, String vehicleId, File imageFile) async {
    try {
      final ref = _storage.ref().child('vehicles/$userId/$vehicleId.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profiles/$userId.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  Future<void> deleteVehicleImage(String userId, String vehicleId) async {
    try {
      final ref = _storage.ref().child('vehicles/$userId/$vehicleId.jpg');
      await ref.delete();
    } catch (e) {
      // Ignore if file doesn't exist
      if (e is FirebaseException && e.code == 'object-not-found') {
        return;
      }
      throw Exception('Failed to delete image: $e');
    }
  }
}


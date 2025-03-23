import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:washee/models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BookingProvider() {
    _initBookingsListener();
  }

  void _initBookingsListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToUserBookings(user.uid);
      } else {
        _bookings = [];
        notifyListeners();
      }
    });
  }

  void _listenToUserBookings(String userId) {
    _database.child('bookings').orderByChild('userId').equalTo(userId).onValue.listen((event) {
      _bookings = [];
      
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        
        data.forEach((key, value) {
          final booking = _parseBooking(key.toString(), value as Map<dynamic, dynamic>);
          _bookings.add(booking);
        });
      }
      
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      notifyListeners();
    });
  }

  Booking _parseBooking(String id, Map<dynamic, dynamic> data) {
    return Booking(
      id: id,
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime'] ?? 0),
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
    );
  }

  Booking? getUpcomingBooking() {
    final now = DateTime.now();
    final upcomingBookings = _bookings
        .where((booking) => 
            booking.dateTime.isAfter(now) && 
            booking.status.toLowerCase() != 'cancelled')
        .toList();
    
    upcomingBookings.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    return upcomingBookings.isNotEmpty ? upcomingBookings.first : null;
  }

  List<Booking> getUpcomingBookings() {
    final now = DateTime.now();
    final upcomingBookings = _bookings
        .where((booking) => 
            booking.dateTime.isAfter(now) && 
            booking.status.toLowerCase() != 'cancelled')
        .toList();
    
    upcomingBookings.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    return upcomingBookings;
  }

  List<Booking> getPastBookings() {
    final now = DateTime.now();
    final pastBookings = _bookings
        .where((booking) => 
            booking.dateTime.isBefore(now) || 
            booking.status.toLowerCase() == 'cancelled')
        .toList();
    
    pastBookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
    return pastBookings;
  }

  Future<void> addBooking(String serviceId, String serviceName, String vehicleId, DateTime dateTime, double price) async {
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
      
      final newBookingRef = _database.child('bookings').push();
      
      await newBookingRef.set({
        'userId': user.uid,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'vehicleId': vehicleId,
        'dateTime': dateTime.millisecondsSinceEpoch,
        'price': price,
        'status': 'confirmed',
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

  Future<void> cancelBooking(String bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _database.child('bookings').child(bookingId).update({
        'status': 'cancelled',
        'updatedAt': ServerValue.timestamp,
      });
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}


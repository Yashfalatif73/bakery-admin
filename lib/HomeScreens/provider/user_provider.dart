import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String name;
  final double revenue;
  final int totalOrders;

  UserData({
    this.name = '',
    this.revenue = 0.0,
    this.totalOrders = 0,
  });

  factory UserData.fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserData();
    
    return UserData(
      name: map['name'] ?? '',
      revenue: map['revenue'] != null ? (map['revenue'] as num).toDouble() : 0.0,
      totalOrders: map['totalOrders'] ?? 0,
    );
  }
}

class UserProvider extends ChangeNotifier {
  UserData _userData = UserData();
  bool _isLoading = false;
  String? _error;

  UserData get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch current user data
  Future<void> fetchCurrentUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get current user ID
      final User? user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('No user is currently logged in');
      }

      // Fetch user data from admins collection
      final DocumentSnapshot userDoc = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found in admins collection');
      }

      // Convert document to map
      final Map<String, dynamic> userData = 
          userDoc.data() as Map<String, dynamic>;

      // Create UserData object
      _userData = UserData.fromMap(userData);
      _isLoading = false;
      notifyListeners();
      
      print('User data loaded: ${_userData.name}, Revenue: ${_userData.revenue}, Orders: ${_userData.totalOrders}');
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Method to refresh user data
  Future<void> refreshUserData() async {
    await fetchCurrentUserData();
  }
}
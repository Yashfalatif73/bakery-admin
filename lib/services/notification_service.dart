import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class MessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _jsonPath = "images/food.json";
  static const _fcmApi = "https://fcm.googleapis.com/v1/projects/ecomm-ff529/messages:send";
  static const List<String> _scopes = ["https://www.googleapis.com/auth/cloud-platform"];

  static Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _messaging.onTokenRefresh.listen((newToken) {
      _updateTokenInDatabase(newToken);
    });

    final token = await _messaging.getToken();
    if (token != null) {
      await _updateTokenInDatabase(token);
    }
  }

  static Future<void> _updateTokenInDatabase(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userRef = _firestore.collection('admins').doc(userId);
      await userRef.update({
        "tokens": FieldValue.arrayUnion([token])
      });
    }
  }

  static Future<void> removeTokenFromDatabase(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userRef = _firestore.collection('admins').doc(userId);
      await userRef.update({
        "tokens": FieldValue.arrayRemove([token])
      });
    }
  }

  static Future<String> _getAccessToken() async {
    try {
      final jsonCredentials = await rootBundle.loadString(_jsonPath);
      final accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
      
      var client = http.Client();
      AuthClient authClient = await clientViaServiceAccount(accountCredentials, _scopes);
      
      final accessToken = authClient.credentials.accessToken.data;
      client.close();
      
      return accessToken;
    } catch (e) {
      log('Error getting access token: $e');
      return '';
    }
  }
  static Future<void> sendNotification({
    required List<String> tokens,
    required String title,
    required String body,
  }) async {
    String accessToken = await _getAccessToken();
    
    for (String token in tokens) {
      Map<String, dynamic> notificationPayload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          }
        }
      };

      try {
        final response = await http.post(
          Uri.parse(_fcmApi),
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
          body: jsonEncode(notificationPayload),
        );

        if (response.statusCode == 200) {
          log('Notification sent successfully to $token');
        } else {
          log('Error sending notification: ${response.statusCode}, ${response.body}');
          
          if (response.statusCode == 404) {
            final responseBody = jsonDecode(response.body);
            final errorCode = responseBody['error']?['details']?[0]?['errorCode'];
            if (errorCode == 'UNREGISTERED') {
              log('Token is unregistered. Removing token from database.');
              await removeTokenFromDatabase(token);
            }
          }
        }
      } catch (e) {
        log('Exception sending notification: $e');
      }
    }
  }
}
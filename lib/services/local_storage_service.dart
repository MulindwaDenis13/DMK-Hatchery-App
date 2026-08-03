import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/models.dart';

/// A service responsible for securely storing and retrieving
/// authentication-related data such as the user token and profile.
///
/// This uses [FlutterSecureStorage], which stores data securely
/// using the device's encrypted storage (Keychain on iOS and
/// EncryptedSharedPreferences/Keystore on Android).
class LocalStorageService {
  /// Secure storage instance injected into the service.
  final FlutterSecureStorage storage;

  LocalStorageService({
    required this.storage,
  });

  /// Saves the authentication token securely.
  ///
  /// Parameters:
  /// - [token]: The JWT or access token received after login.
  Future saveToken(String token) async {
    return await storage.write(
      key: "token",
      value: token,
    );
  }

  /// Retrieves the saved authentication token.
  ///
  /// Returns:
  /// - The stored token if available.
  /// - An empty string if no token exists.
  Future<String> readToken() async {
    final savedToken = await storage.read(key: "token") ?? "";
    return savedToken;
  }

  /// Saves the authenticated user's information.
  ///
  /// The [Customer] object is converted to JSON and stored
  /// as a string in secure storage.
  Future saveUser(Customer user) async {
    // Convert the user object into a JSON string.
    final userData = jsonEncode(user.toJson());

    return await storage.write(
      key: "user",
      value: userData,
    );
  }

  /// Retrieves the stored user information.
  ///
  /// Returns:
  /// - A [Customer] object if user data exists.
  /// - `null` if no user has been saved.
  Future<Customer?> getUser() async {
    // Read the stored JSON string.
    final savedUserData = await storage.read(key: "user");

    if (savedUserData != null) {
      // Convert the JSON string back into a Map.
      final json = jsonDecode(savedUserData);

      // Create a Customer object from the JSON map.
      return Customer.fromJson(json);
    }

    return null;
  }

  /// Clears all data stored in secure storage.
  ///
  /// Typically called during logout to remove the token,
  /// user information, and any other securely stored values.
  Future clearStorage() async {
    return await storage.deleteAll();
  }
}
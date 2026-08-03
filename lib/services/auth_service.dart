import '../api/api_client.dart';
import '../models/api_response.dart';
import '../models/models.dart';
import '../services/local_storage_service.dart';

/// Service responsible for user authentication.
///
/// This class communicates with the API through [ApiClient]
/// and persists authentication data using [LocalStorageService].
class AuthService {
  /// Handles all HTTP requests.
  final ApiClient apiClient;

  /// Handles secure local storage.
  final LocalStorageService localStorageService;

  AuthService({
    required this.apiClient,
    required this.localStorageService,
  });

  /// Authenticates a customer.
  ///
  /// On success:
  /// - Saves the authentication token.
  /// - Saves the authenticated customer.
  /// - Returns an [ApiResponse.success].
  ///
  /// On failure:
  /// - Returns an [ApiResponse.failure] with the error message.
  Future<ApiResponse<Customer>> login({
    required String phone,
    required String password,
  }) async {
    try {
      // Prepare login payload.
      final loginData = {
        "phone": phone,
        "password": password,
      };

      // Send login request.
      final response = await apiClient.postData(
        "login",
        loginData,
      );

      // Check whether authentication was successful.
      if (response['success'] == true) {
        // Extract API response data.
        final data = response['data'];

        // Create customer object.
        final customer = Customer.fromJson(data['customer']);

        // Save authentication token.
        await localStorageService.saveToken(data['token']);

        // Save authenticated user.
        await localStorageService.saveUser(customer);

        return ApiResponse.success(
          message: response['message'] ?? "Login successful",
          data: customer,
        );
      }

      // API returned an unsuccessful response.
      return ApiResponse.failure(
        error: response['message'] ?? response['error'] ?? "Login failed",
      );
    } catch (e) {
      return ApiResponse.failure(
        error: e.toString(),
      );
    }
  }

  /// Logs the authenticated user out.
  ///
  /// This:
  /// 1. Notifies the backend.
  /// 2. Clears all locally stored authentication data.
  Future<void> logout() async {
    try {
      await apiClient.postData(
        "logout",
        {},
      );
    } finally {
      // Always clear local storage even if the server request fails.
      await localStorageService.clearStorage();
    }
  }

  /// Returns the currently authenticated customer stored locally.
  ///
  /// Returns `null` if no user is logged in.
  Future<Customer?> currentUser() async {
    return localStorageService.getUser();
  }

  /// Returns the stored authentication token.
  Future<String> token() async {
    return localStorageService.readToken();
  }

  /// Returns whether a user is authenticated.
  Future<bool> isLoggedIn() async {
    final token = await localStorageService.readToken();
    return token.isNotEmpty;
  }
}

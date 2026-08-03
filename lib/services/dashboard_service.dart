import '../api/api_client.dart';
import '../models/api_response.dart';
import '../models/models.dart';

class DashboardService {
  final ApiClient apiClient;

  DashboardService({
    required this.apiClient,
  });

  Future<ApiResponse<Dashboard>> getDashboardStats() async {
    try {
      final response = await apiClient.getData('dashboard');

      if (response['success'] == true) {
        return ApiResponse.success(
          message: response['message'] ?? 'Dashboard loaded successfully',
          data: Dashboard.fromJson(response['data']),
        );
      }

      return ApiResponse.failure(
        error: response['message'] ??
            response['error'] ??
            'Failed to load dashboard',
      );
    } catch (e) {
      return ApiResponse.failure(
        error: e.toString(),
      );
    }
  }
}

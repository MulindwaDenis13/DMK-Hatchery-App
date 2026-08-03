import '../api/api_client.dart';
import '../models/api_response.dart';
import '../models/models.dart';

class BatchService {
  final ApiClient apiClient;

  const BatchService({
    required this.apiClient,
  });

  Future<ApiResponse<Pagination<Batch>>> getBatches({
    required int page,
    String? status,
    String? search,
    int perPage = 10,
  }) async {
    try {
      final params = <String, String>{
        'page': '$page',
        'per_page': '$perPage',
      };

      if (status != null &&
          status.isNotEmpty &&
          status.toLowerCase() != 'all') {
        params['status'] = status;
      }

      if (search != null && search.trim().isNotEmpty) {
        params['search'] = search.trim();
      }

      final response = await apiClient.getData(
        'batches?${Uri(queryParameters: params).query}',
      );

      if (response['success'] != true) {
        return ApiResponse.failure(
          error: response['message'] ??
              response['error'] ??
              'Failed to load batches',
        );
      }

      return ApiResponse.success(
        message: response['message'] ?? 'Batches loaded successfully',
        data: Pagination<Batch>.fromJson(
          response['data'],
          Batch.fromJson,
        ),
      );
    } catch (e) {
      return ApiResponse.failure(
        error: e.toString(),
      );
    }
  }
}

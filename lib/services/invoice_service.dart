import '../api/api_client.dart';
import '../models/api_response.dart';
import '../models/models.dart';

class InvoiceService {
  final ApiClient apiClient;

  const InvoiceService({
    required this.apiClient,
  });

  Future<ApiResponse<Pagination<Invoice>>> getInvoices({
    required int page,
    String? status,
    String? search,
    int perPage = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': '$page',
        'per_page': '$perPage',
      };

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final endpoint = queryParameters.isEmpty
          ? 'invoices'
          : 'invoices?${Uri(queryParameters: queryParameters).query}';

      final response = await apiClient.getData(endpoint);

      if (response['success'] == true) {
        return ApiResponse.success(
          message: response['message'] ?? 'Invoices loaded successfully',
          data: Pagination<Invoice>.fromJson(
            response['data'],
            Invoice.fromJson,
          ),
        );
      }

      return ApiResponse.failure(
        error: response['message'] ??
            response['error'] ??
            'Failed to load invoices',
      );
    } catch (e) {
      return ApiResponse.failure(
        error: e.toString(),
      );
    }
  }
}

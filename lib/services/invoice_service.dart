import '../api/api_client.dart';
import '../models/api_response.dart';
import '../models/models.dart';

class InvoiceService {
  final ApiClient apiClient;

  const InvoiceService({
    required this.apiClient,
  });

  // ============================================================
  // GET INVOICES
  // ============================================================

  Future<ApiResponse<Pagination<InvoiceList>>> getInvoices({
    required int page,
    String? status,
    String? search,
    int perPage = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (status != null &&
          status.isNotEmpty &&
          status.toLowerCase() != 'all') {
        queryParameters['status'] = status;
      }

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final endpoint =
          'invoices?${Uri(queryParameters: queryParameters).query}';

      final response = await apiClient.getData(endpoint);

      if (response['success'] == true) {
        final rawData = response['data'];

        if (rawData == null) {
          return ApiResponse.failure(
            error: 'Invoice data is missing from the response',
          );
        }

        return ApiResponse.success(
          message: response['message'] ?? 'Invoices loaded successfully',
          data: Pagination<InvoiceList>.fromJson(
            Map<String, dynamic>.from(rawData),
            InvoiceList.fromJson,
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

  // ============================================================
  // GET SINGLE INVOICE
  // ============================================================

  Future<ApiResponse<Invoice>> getInvoice(int id) async {
    try {
      final response = await apiClient.getData(
        'invoice/$id',
      );

      if (response['success'] == true) {
        final rawData = response['data'];

        if (rawData == null) {
          return ApiResponse.failure(
            error: 'Invoice data is missing from the response',
          );
        }

        return ApiResponse.success(
          message: response['message'] ?? 'Invoice loaded successfully',
          data: Invoice.fromJson(
            Map<String, dynamic>.from(rawData),
          ),
        );
      }

      return ApiResponse.failure(
        error: response['message'] ??
            response['error'] ??
            'Failed to load invoice',
      );
    } catch (e) {
      return ApiResponse.failure(
        error: e.toString(),
      );
    }
  }
}

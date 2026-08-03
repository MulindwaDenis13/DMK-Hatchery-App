class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.success({required String message, T? data}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.failure({required String error}) {
    return ApiResponse(success: false, message: error);
  }
}
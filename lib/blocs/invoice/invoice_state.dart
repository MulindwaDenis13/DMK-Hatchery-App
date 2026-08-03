part of 'invoice_bloc.dart';

class InvoiceState extends Equatable {
  final String? error;
  final String? message;
  final AppState status;
  final Pagination<Invoice>? data;
  final bool hasMore;
  final int currentPage;

  const InvoiceState({
    this.error,
    this.message,
    this.data,
    this.status = AppState.initial,
    this.hasMore = false,
    this.currentPage = 0,
  });

  InvoiceState copyWith({
    String? error,
    String? message,
    Pagination<Invoice>? data,
    AppState? status,
    bool? hasMore,
    int? currentPage,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return InvoiceState(
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  factory InvoiceState.initial() {
    return const InvoiceState(
      status: AppState.initial,
      hasMore: true,
      currentPage: 0,
    );
  }

  InvoiceState loading() {
    return copyWith(
      status: AppState.loading,
      clearError: true,
      clearMessage: true,
    );
  }

  InvoiceState success({
    Pagination<Invoice>? data,
    String? message,
    bool hasMore = false,
    int currentPage = 0,
  }) {
    return copyWith(
      status: AppState.success,
      data: data,
      message: message,
      hasMore: hasMore,
      currentPage: currentPage,
      clearError: true,
    );
  }

  InvoiceState loadMoreSuccess({
    Pagination<Invoice>? data,
    String? message,
    bool hasMore = false,
    int currentPage = 0,
  }) {
    Pagination<Invoice>? mergedData;

    if (data != null && this.data != null) {
      mergedData = Pagination<Invoice>(
        currentPage: data.currentPage,
        lastPage: data.lastPage,
        perPage: data.perPage,
        total: data.total,
        hasMore: data.hasMore,
        data: [
          ...this.data!.data,
          ...data.data,
        ],
      );
    } else {
      mergedData = data ?? this.data;
    }

    return InvoiceState(
      status: AppState.success,
      data: mergedData,
      message: message,
      hasMore: hasMore,
      currentPage: currentPage,
    );
  }

  InvoiceState failure({
    required String error,
  }) {
    return copyWith(
      status: AppState.failure,
      error: error,
      hasMore: false,
    );
  }

  List<Invoice> get invoices => data?.data ?? <Invoice>[];

  bool get isLoading => status == AppState.loading;

  bool get isFirstLoad => status == AppState.loading && currentPage == 0;

  bool get isEmpty => invoices.isEmpty;

  @override
  List<Object?> get props => [
        error,
        message,
        data,
        status,
        hasMore,
        currentPage,
      ];
}

final class InvoiceInitial extends InvoiceState {
  const InvoiceInitial()
      : super(
          status: AppState.initial,
          hasMore: true,
          currentPage: 0,
        );
}

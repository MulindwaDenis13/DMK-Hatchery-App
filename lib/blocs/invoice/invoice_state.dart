part of 'invoice_bloc.dart';

class InvoiceState extends Equatable {
  final String? error;
  final String? message;

  final AppState status;

  /// Invoice list
  final Pagination<InvoiceList>? data;

  /// Single invoice
  final Invoice? invoice;

  final bool hasMore;
  final int currentPage;

  const InvoiceState({
    this.error,
    this.message,
    this.status = AppState.initial,
    this.data,
    this.invoice,
    this.hasMore = false,
    this.currentPage = 0,
  });

  InvoiceState copyWith({
    String? error,
    String? message,
    Pagination<InvoiceList>? data,
    Invoice? invoice,
    AppState? status,
    bool? hasMore,
    int? currentPage,
    bool clearError = false,
    bool clearMessage = false,
    bool clearData = false,
    bool clearInvoice = false,
  }) {
    return InvoiceState(
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,

      data: clearData
          ? null
          : data ?? this.data,

      invoice: clearInvoice
          ? null
          : invoice ?? this.invoice,

      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  // ============================================================
  // INITIAL
  // ============================================================

  factory InvoiceState.initial() {
    return const InvoiceState(
      status: AppState.initial,
      hasMore: true,
      currentPage: 0,
    );
  }

  // ============================================================
  // LIST LOADING
  // ============================================================

  InvoiceState loading() {
    return copyWith(
      status: AppState.loading,
      clearError: true,
      clearMessage: true,
    );
  }

  // ============================================================
  // SINGLE INVOICE LOADING
  // ============================================================

  InvoiceState invoiceLoading() {
    return copyWith(
      status: AppState.loading,
      clearError: true,
      clearMessage: true,
      clearInvoice: true,
    );
  }

  // ============================================================
  // LIST SUCCESS
  // ============================================================

  InvoiceState success({
    required Pagination<InvoiceList> data,
    String? message,
    bool? hasMore,
    int? currentPage,
  }) {
    return copyWith(
      status: AppState.success,
      data: data,
      message: message,
      hasMore: hasMore ?? data.hasMore,
      currentPage: currentPage ?? data.currentPage,
      clearError: true,
    );
  }

  // ============================================================
  // SINGLE INVOICE SUCCESS
  // ============================================================

  InvoiceState invoiceSuccess({
    required Invoice invoice,
    String? message,
  }) {
    return copyWith(
      status: AppState.success,
      invoice: invoice,
      message: message,
      clearError: true,
      clearData: true,
    );
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  InvoiceState loadMoreSuccess({
    required Pagination<InvoiceList> data,
    String? message,
  }) {
    Pagination<InvoiceList> mergedData;

    if (this.data != null) {
      mergedData = Pagination<InvoiceList>(
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
      mergedData = data;
    }

    return copyWith(
      status: AppState.success,
      data: mergedData,
      message: message,
      hasMore: data.hasMore,
      currentPage: data.currentPage,
      clearError: true,
    );
  }

  // ============================================================
  // FAILURE
  // ============================================================

  InvoiceState failure({
    required String error,
  }) {
    return copyWith(
      status: AppState.failure,
      error: error,
      hasMore: false,
    );
  }

  // ============================================================
  // GETTERS
  // ============================================================

  List<InvoiceList> get invoices => data?.data ?? <InvoiceList>[];
  

  bool get isLoading => status == AppState.loading;
  

  bool get isFirstLoad => status == AppState.loading && currentPage == 0;
  

  bool get isEmpty => invoices.isEmpty;
  

  bool get hasInvoice => invoice != null;
  

  bool get isInvoiceLoading {
    return status == AppState.loading && invoice == null;
  }

  @override
  List<Object?> get props => [
        error,
        message,
        status,
        data,
        invoice,
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
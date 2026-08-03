part of 'batch_bloc.dart';

class BatchState extends Equatable {
  final String? error;
  final String? message;
  final AppState status;
  final Pagination<Batch>? data;
  final bool hasMore;
  final int currentPage;

  const BatchState({
    this.error,
    this.message,
    this.data,
    this.status = AppState.initial,
    this.hasMore = false,
    this.currentPage = 0,
  });

  BatchState copyWith({
    String? error,
    String? message,
    Pagination<Batch>? data,
    AppState? status,
    bool? hasMore,
    int? currentPage,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return BatchState(
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  factory BatchState.initial() {
    return const BatchState(
      status: AppState.initial,
      hasMore: true,
      currentPage: 0,
    );
  }

  BatchState loading() {
    return copyWith(
      status: AppState.loading,
      clearError: true,
      clearMessage: true,
    );
  }

  BatchState success({
    Pagination<Batch>? data,
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

  BatchState loadMoreSuccess({
    Pagination<Batch>? data,
    String? message,
    bool hasMore = false,
    int currentPage = 0,
  }) {
    Pagination<Batch>? mergedData;

    if (data != null && this.data != null) {
      mergedData = Pagination<Batch>(
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

    return BatchState(
      status: AppState.success,
      data: mergedData,
      message: message,
      hasMore: hasMore,
      currentPage: currentPage,
    );
  }

  BatchState failure({
    required String error,
  }) {
    return copyWith(
      status: AppState.failure,
      error: error,
      hasMore: false,
    );
  }

  List<Batch> get batches => data?.data ?? <Batch>[];

  bool get isLoading => status == AppState.loading;

  bool get isFirstLoad => status == AppState.loading && currentPage == 0;

  bool get isEmpty => batches.isEmpty;

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

final class BatchInitial extends BatchState {
  const BatchInitial()
      : super(
          status: AppState.initial,
          hasMore: true,
          currentPage: 0,
        );
}

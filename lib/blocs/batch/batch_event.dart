part of 'batch_bloc.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();

  @override
  List<Object?> get props => [];
}

// Load batches for the first time or with new filters
final class BatchLoadRequested extends BatchEvent {
  final String status;
  final String search;
  final int page;

  const BatchLoadRequested({
    this.status = '',
    this.search = '',
    this.page = 1,
  });

  @override
  List<Object?> get props => [status, search, page];
}

// Load more batches for infinite scroll
final class BatchLoadMoreRequested extends BatchEvent {
  final String status;
  final String search;
  final int page;

  const BatchLoadMoreRequested({
    this.status = '',
    this.search = '',
    required this.page,
  });

  @override
  List<Object?> get props => [status, search, page];
}

// Refresh the batch list (pull to refresh)
final class BatchRefreshRequested extends BatchEvent {
  final String status;
  final String search;

  const BatchRefreshRequested({
    this.status = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [status, search];
}

// Reset the batch state
final class BatchResetRequested extends BatchEvent {
  const BatchResetRequested();

  @override
  List<Object?> get props => [];
}

// Handle batch loading failure
final class BatchLoadFailure extends BatchEvent {
  final String error;

  const BatchLoadFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

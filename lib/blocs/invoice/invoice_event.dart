part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

// Load invoices for the first time or with new filters
final class InvoiceLoadRequested extends InvoiceEvent {
  final String status;
  final String search;
  final int page;

  const InvoiceLoadRequested({
    this.status = '',
    this.search = '',
    this.page = 1,
  });

  @override
  List<Object> get props => [status, search, page];
}

// Load more invoices for infinite scroll
final class InvoiceLoadMoreRequested extends InvoiceEvent {
  final String status;
  final String search;
  final int page;

  const InvoiceLoadMoreRequested({
    this.status = '',
    this.search = '',
    required this.page,
  });

  @override
  List<Object> get props => [status, search, page];
}

// Refresh the invoice list (pull to refresh)
final class InvoiceRefreshRequested extends InvoiceEvent {
  final String status;
  final String search;

  const InvoiceRefreshRequested({
    this.status = '',
    this.search = '',
  });

  @override
  List<Object> get props => [status, search];
}

// Reset the invoice state
final class InvoiceResetRequested extends InvoiceEvent {
  const InvoiceResetRequested();

  @override
  List<Object> get props => [];
}

// Handle invoice loading failure
final class InvoiceLoadFailure extends InvoiceEvent {
  final String error;

  const InvoiceLoadFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class InvoiceLoadSingleRequested extends InvoiceEvent {
  final int invoiceId;

  InvoiceLoadSingleRequested({
    required this.invoiceId,
  });

  @override
  List<Object> get props => [invoiceId];
}

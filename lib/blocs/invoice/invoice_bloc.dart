import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../models/enums.dart';
import '../../services/invoice_service.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceService _invoiceService;
  InvoiceBloc({
    required InvoiceService invoiceService,
  })  : _invoiceService = invoiceService,
        super(InvoiceInitial()) {
    on<InvoiceLoadRequested>(_onInvoiceLoadRequested);
    on<InvoiceLoadMoreRequested>(_onInvoiceLoadMoreRequested);
    on<InvoiceRefreshRequested>(_onInvoiceRefreshRequested);
    on<InvoiceResetRequested>(_onInvoiceResetRequested);
    on<InvoiceLoadFailure>(_onInvoiceLoadFailure);
  }

  Future<void> _onInvoiceLoadRequested(
    InvoiceLoadRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.loading());

    try {
      final response = await _invoiceService.getInvoices(
        page: event.page,
        status: event.status,
        search: event.search,
      );

      if (response.success) {
        final data = response.data!;
        emit(
          state.success(
            data: data,
            hasMore: data.hasMore,
            currentPage: data.currentPage,
            message: 'Invoices loaded successfully',
          ),
        );
      } else {
        emit(
          state.failure(
            error: response.message,
          ),
        );
      }
    } catch (e) {
      emit(state.failure(error: e.toString()));
    }
  }

  Future<void> _onInvoiceLoadMoreRequested(
    InvoiceLoadMoreRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;

    try {
      final response = await _invoiceService.getInvoices(
        page: event.page,
        status: event.status,
        search: event.search,
      );

      if (response.success) {
        final data = response.data!;
        emit(
          state.success(
            data: data,
            hasMore: data.hasMore,
            currentPage: data.currentPage,
            message: 'Batches loaded successfully',
          ),
        );
      } else {
        emit(
          state.failure(
            error: response.message,
          ),
        );
      }
    } catch (e) {
      // Optionally emit failure or just log error
      emit(state.failure(error: e.toString()));
    }
  }

  Future<void> _onInvoiceRefreshRequested(
    InvoiceRefreshRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    // Reset state and reload from page 1
    emit(InvoiceState.initial());
    add(InvoiceLoadRequested(
      status: event.status,
      search: event.search,
    ));
  }

  void _onInvoiceResetRequested(
    InvoiceResetRequested event,
    Emitter<InvoiceState> emit,
  ) {
    emit(InvoiceState.initial());
  }

  void _onInvoiceLoadFailure(
    InvoiceLoadFailure event,
    Emitter<InvoiceState> emit,
  ) {
    emit(state.failure(error: event.error));
  }
}

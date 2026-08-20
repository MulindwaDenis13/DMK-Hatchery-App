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
        super(const InvoiceInitial()) {
    on<InvoiceLoadRequested>(_onInvoiceLoadRequested);
    on<InvoiceLoadMoreRequested>(_onInvoiceLoadMoreRequested);
    on<InvoiceRefreshRequested>(_onInvoiceRefreshRequested);
    on<InvoiceResetRequested>(_onInvoiceResetRequested);
    on<InvoiceLoadFailure>(_onInvoiceLoadFailure);
    on<InvoiceLoadSingleRequested>(_onInvoiceLoadSingleRequested);
  }

  // ============================================================
  // LOAD INVOICE LIST
  // ============================================================

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

      if (response.success && response.data != null) {
        final data = response.data!;
        emit(
          state.success(
            data: data,
            hasMore: data.hasMore,
            currentPage: data.currentPage,
            message: response.message.isNotEmpty
                ? response.message
                : 'Invoices loaded successfully',
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
      emit(
        state.failure(
          error: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // LOAD MORE INVOICES
  // ============================================================

  Future<void> _onInvoiceLoadMoreRequested(
    InvoiceLoadMoreRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) {
      return;
    }

    try {
      final response = await _invoiceService.getInvoices(
        page: event.page,
        status: event.status,
        search: event.search,
      );

      if (response.success && response.data != null) {
        final data = response.data!;

        emit(
          state.loadMoreSuccess(
            data: data,
            message: response.message,
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
      emit(
        state.failure(
          error: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // LOAD SINGLE INVOICE
  // ============================================================

  Future<void> _onInvoiceLoadSingleRequested(
    InvoiceLoadSingleRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(
      state.invoiceLoading(),
    );

    try {
      final response = await _invoiceService.getInvoice(
        event.invoiceId,
      );

      if (response.success && response.data != null) {
        emit(
          state.invoiceSuccess(
            invoice: response.data!,
            message: response.message,
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
      emit(
        state.failure(
          error: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _onInvoiceRefreshRequested(
    InvoiceRefreshRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(
      InvoiceState.initial(),
    );

    add(
      InvoiceLoadRequested(
        page: 1,
        status: event.status,
        search: event.search,
      ),
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void _onInvoiceResetRequested(
    InvoiceResetRequested event,
    Emitter<InvoiceState> emit,
  ) {
    emit(
      InvoiceState.initial(),
    );
  }

  // ============================================================
  // FAILURE
  // ============================================================

  void _onInvoiceLoadFailure(
    InvoiceLoadFailure event,
    Emitter<InvoiceState> emit,
  ) {
    emit(
      state.failure(
        error: event.error,
      ),
    );
  }
}
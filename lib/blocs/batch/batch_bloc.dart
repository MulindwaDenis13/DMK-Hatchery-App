import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../models/enums.dart';
import '../../services/batch_service.dart';

part 'batch_event.dart';
part 'batch_state.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final BatchService _batchService;

  BatchBloc({
    required BatchService batchService,
  })  : _batchService = batchService,
        super(BatchState.initial()) {
    on<BatchLoadRequested>(_onBatchLoadRequested);
    on<BatchLoadMoreRequested>(_onBatchLoadMoreRequested);
    on<BatchRefreshRequested>(_onBatchRefreshRequested);
    on<BatchResetRequested>(_onBatchResetRequested);
    on<BatchLoadFailure>(_onBatchLoadFailure);
  }

  Future<void> _onBatchLoadRequested(
    BatchLoadRequested event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.loading());

    try {
      final response = await _batchService.getBatches(
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
      emit(state.failure(error: e.toString()));
    }
  }

  Future<void> _onBatchLoadMoreRequested(
    BatchLoadMoreRequested event,
    Emitter<BatchState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;

    try {
      final response = await _batchService.getBatches(
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

  Future<void> _onBatchRefreshRequested(
    BatchRefreshRequested event,
    Emitter<BatchState> emit,
  ) async {
    // Reset state and reload from page 1
    emit(BatchState.initial());
    add(BatchLoadRequested(
      status: event.status,
      search: event.search,
      page: 1,
    ));
  }

  void _onBatchResetRequested(
    BatchResetRequested event,
    Emitter<BatchState> emit,
  ) {
    emit(BatchState.initial());
  }

  void _onBatchLoadFailure(
    BatchLoadFailure event,
    Emitter<BatchState> emit,
  ) {
    emit(state.failure(error: event.error));
  }
}

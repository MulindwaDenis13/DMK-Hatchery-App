import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/enums.dart';
import '../../models/models.dart';

import '../../services/dashboard_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService dashboardService;
  DashboardBloc({
    required this.dashboardService,
  }) : super(DashboardState(
          status: AppState.initial,
        )) {
    on<GetDashboardStats>((event, emit) async {
      emit(
        state.loading(),
      );

      try {
        final response = await dashboardService.getDashboardStats();

        if (response.success) {
          emit(
            state.success(
              message: response.message,
              data: response.data,
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
    });
  }
}

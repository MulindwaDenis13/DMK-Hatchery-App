part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String? error;
  final String? message;
  final AppState status;
  final Dashboard? data;

  const DashboardState({
    this.error,
    this.message,
    this.data,
    this.status = AppState.initial,
  });

  DashboardState copyWith({
    String? error,
    String? message,
    Dashboard? data,
    AppState? status,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return DashboardState(
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  factory DashboardState.initial() {
    return const DashboardState(
      status: AppState.initial,
    );
  }

  DashboardState loading() {
    return copyWith(
      status: AppState.loading,
      clearError: true,
      clearMessage: true,
    );
  }

  DashboardState success({
    Dashboard? data,
    String? message,
  }) {
    return copyWith(
      status: AppState.success,
      data: data,
      message: message,
      clearError: true,
    );
  }

  DashboardState failure({
    required String error,
  }) {
    return copyWith(
      status: AppState.failure,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        error,
        message,
        data,
        status,
      ];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial()
      : super(
          status: AppState.initial,
        );
}
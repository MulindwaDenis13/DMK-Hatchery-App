enum AppState {
  initial,
  loading,
  success,
  failure,
}

extension AppStateEX on AppState {
  bool get isInitial => this == AppState.initial;

  bool get isLoading => this == AppState.loading;

  bool get isSuccess => this == AppState.success;

  bool get isFailure => this == AppState.failure;
}

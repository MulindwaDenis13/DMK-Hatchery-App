part of 'auth_bloc.dart';

/// Represents the current authentication state.
///
/// The AuthBloc emits this state whenever authentication data changes.
/// The UI listens to these changes and rebuilds accordingly.
class AuthState extends Equatable {
  /// Error message returned when authentication fails.
  final String? error;

  /// Success or informational message.
  final String? message;

  /// Current authentication request status.
  ///
  /// Examples:
  /// - AppState.initial
  /// - AppState.loading
  /// - AppState.success
  /// - AppState.failure
  final AppState status;

  /// Currently authenticated customer.
  final Customer? data;

  /// Creates an authentication state.
  const AuthState({
    this.error,
    this.message,
    this.data,
    this.status = AppState.initial,
  });


  /// Creates a new AuthState with updated values.
  ///
  /// Existing values are preserved unless a new value is provided.
  AuthState copyWith({
    String? error,
    String? message,
    AppState? status,
    Customer? data,
  }) {
    return AuthState(
      error: error ?? this.error,
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }


  /// Creates the initial authentication state.
  ///
  /// Used when the application starts.
  AuthState initial() {
    return const AuthState(
      status: AppState.initial,
    );
  }


  /// Creates a loading authentication state.
  ///
  /// Used when:
  /// - Login request starts.
  /// - User data is being fetched.
  AuthState loading() {
    return copyWith(
      status: AppState.loading,
      error: null,
      message: null,
    );
  }


  /// Creates a successful authentication state.
  ///
  /// Stores:
  /// - Success message.
  /// - Logged-in customer information.
  AuthState success({
    String? message,
    Customer? data,
  }) {
    return copyWith(
      status: AppState.success,
      message: message,
      data: data,
      error: null,
    );
  }


  /// Creates a failed authentication state.
  ///
  /// Stores the API error message.
  AuthState failure({
    required String error,
  }) {
    return copyWith(
      status: AppState.failure,
      error: error,
    );
  }


  /// Defines which properties are compared by Equatable.
  ///
  /// Bloc uses these values to determine whether the state changed.
  @override
  List<Object?> get props => [
        error,
        message,
        status,
        data,
      ];
}


/// The first state emitted when AuthBloc is created.
///
/// No authentication action has happened yet.
final class AuthInitial extends AuthState {
  const AuthInitial()
      : super(
          status: AppState.initial,
        );
}
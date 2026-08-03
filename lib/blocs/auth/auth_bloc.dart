import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/enums.dart';
import '../../models/models.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';


/// Handles all authentication-related business logic.
///
/// Responsibilities:
/// - Processing login requests.
/// - Managing authentication states.
/// - Handling logout.
/// - Communicating with [AuthService].
///
/// The UI communicates with this Bloc by dispatching events
/// and listening to emitted states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  /// Service responsible for API authentication operations.
  final AuthService authService;


  /// Creates an AuthBloc.
  ///
  /// The initial state is [AppState.initial],
  /// meaning no authentication action has happened yet.
  AuthBloc({
    required this.authService,
  }) : super(
          const AuthState(
            status: AppState.initial,
          ),
        ) {


    /// Handles user login requests.
    ///
    /// Flow:
    /// 1. Emit loading state.
    /// 2. Call AuthService login API.
    /// 3. Emit success or failure state.
    on<Login>((event, emit) async {

      // Notify UI that login is in progress.
      emit(
        state.loading(),
      );


      try {

        // Send login credentials to authentication service.
        final response = await authService.login(
          phone: event.phone,
          password: event.password,
        );


        // Check API response status.
        if (response.success) {

          // Login successful.
          // Store customer data and success message.
          emit(
            state.success(
              message: response.message,
              data: response.data,
            ),
          );

        } else {

          // Login failed from API response.
          emit(
            state.failure(
              error: response.message,
            ),
          );
        }


      } catch (e) {

        // Handle unexpected errors such as:
        // - Network failure
        // - Server errors
        // - Parsing errors
        emit(
          state.failure(
            error: e.toString(),
          ),
        );
      }
    });



    /// Handles user logout requests.
    ///
    /// Flow:
    /// 1. Call logout API.
    /// 2. Clear local authentication data.
    /// 3. Reset application state.
    on<Logout>((event, emit) async {

      await authService.logout();


      // Return application to initial state.
      emit(
        const AuthState(
          status: AppState.initial,
        ),
      );
    });



    /// Handles authentication failures triggered manually.
    ///
    /// Example:
    /// - Token expired.
    /// - User session invalid.
    on<AuthFailure>((event, emit) {

      emit(
        state.failure(
          error: event.error,
        ),
      );
    });

  }
}
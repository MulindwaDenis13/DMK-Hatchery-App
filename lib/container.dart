import 'services/services.dart';
import 'api/api_client.dart';
import 'package:get_it/get_it.dart';
import './blocs/blocs.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //api client
  sl.registerLazySingleton(
    () => ApiClient(
      localStorageService: sl(),
    ),
  );

  //services
  sl.registerLazySingleton(
    () => LocalStorageService(
      storage: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AuthService(
      localStorageService: sl(),
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => DashboardService(
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => BatchService(
      apiClient: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => InvoiceService(
      apiClient: sl(),
    ),
  );

  //blocs
  sl.registerFactory(
    () => AuthBloc(
      authService: sl(),
    ),
  );

  sl.registerFactory(
    () => DashboardBloc(
      dashboardService: sl(),
    ),
  );

  sl.registerFactory(
    () => BatchBloc(
      batchService: sl(),
    ),
  );

  sl.registerFactory(
    () => InvoiceBloc(
      invoiceService: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}

List<BlocProvider> get blocs => [
      BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>(),
      ),
      BlocProvider<DashboardBloc>(
        create: (context) => sl<DashboardBloc>(),
      ),
      BlocProvider<BatchBloc>(
        create: (context) => sl<BatchBloc>(),
      ),
      BlocProvider<InvoiceBloc>(
        create: (context) => sl<InvoiceBloc>(),
      ),
    ];

Future logout() async {
  sl<AuthBloc>().add(Logout());
}

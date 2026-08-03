import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/splash.dart';
import './container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: di.blocs,
      child: MaterialApp(
        title: 'DMK Hatchery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey.shade50,
          fontFamily: 'Segoe UI',
        ),
        home: SplashScreen(),
      ),
    );
  }
}

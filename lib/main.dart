import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recovery_app/resources/route_manager.dart';
import 'package:recovery_app/resources/theme_manager.dart';
import 'package:recovery_app/screens/BottomNav/bottom_nav.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/initialScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/screens/authentication/otp_login.dart';
import 'package:recovery_app/storage/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeDatabase();

  runApp(
    MultiBlocProvider(
        providers: [BlocProvider(create: (c) => HomeCubit())],
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      theme: getApplicationTheme(),
      routes: {
        '/': (context) => const InitialScreen(),
        '/login': (context) => const Login(),
        // '/otp-login': (context) => const BottomNavView(),
        '/otp-login': (context) => const OtpLogin(),
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

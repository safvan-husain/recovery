import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:recovery_app/resources/route_manager.dart';
import 'package:recovery_app/resources/theme_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/initialScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/screens/authentication/otp_login.dart';
import 'package:recovery_app/services/excel_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExcelStore.initilize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(
    MultiBlocProvider(
        providers: [BlocProvider(create: (c) => HomeCubit())],
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  // MyApp._internal();  //Private Named Constructor
  // int appState = 0;
  // static final MyApp instance = MyApp._internal();  //Single Instance -- Singleton
  // factory MyApp() =>instance; //factory for class Instance
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

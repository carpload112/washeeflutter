import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washee/firebase_options.dart';
import 'package:washee/providers/auth_provider.dart';
import 'package:washee/providers/booking_provider.dart';
import 'package:washee/providers/vehicle_provider.dart';
import 'package:washee/screens/splash_screen.dart';
import 'package:washee/services/ios_firebase_init.dart';
import 'package:washee/theme/app_theme.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize iOS-specific Firebase settings if on iOS
  if (Platform.isIOS) {
    await IOSFirebaseInit.initialize();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: MaterialApp(
        title: 'Washee',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}


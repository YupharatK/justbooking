import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_booking/users/home_page.dart';
import 'package:just_booking/wellcome/wellcome.dart';
import 'package:just_booking/dormitory/dormitory_home_page.dart';

import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
      }
    }
  } else {
    if (kDebugMode) {
      print('Bypassed Firebase initialization on Web');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Booking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A84ED)),
        useMaterial3: true,
      ),
      home: const WellcomePage()
    );
  }
}

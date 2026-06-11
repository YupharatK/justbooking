import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_booking/users/home_page.dart';
import 'package:just_booking/wellcome/login.dart';
import 'package:just_booking/services/auth_service.dart';
import 'package:just_booking/dormitory/dormitory_home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_booking/l10n/generated/app_localizations.dart';
import 'package:just_booking/core/localization/locale_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_booking/services/notification_service.dart';
import 'package:flutter/foundation.dart';

final localeController = LocaleController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localeController.init();

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      // Set the background messaging handler early on, as a named top-level function
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      // Initialize Local and Foreground Notifications
      await NotificationService().init();
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
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Just Booking',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A84ED)),
            useMaterial3: true,
            textTheme: GoogleFonts.notoSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          locale: localeController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('th'),
            Locale('en'),
            Locale('zh'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
            }
            return const Locale('en'); // Fallback to English if not supported
          },
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Widget _homeScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        if (mounted) {
          setState(() {
            _homeScreen = user.role == 'owner' 
                ? const DormitoryHomePage() 
                : const UserHomePage();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _homeScreen = const UserHomePage(isGuest: true);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _homeScreen = const UserHomePage(isGuest: true);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF5A84ED),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return _homeScreen;
  }
}

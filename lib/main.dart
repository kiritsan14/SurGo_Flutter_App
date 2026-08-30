import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/matching_screen.dart';
import 'screens/live_trip_screen.dart';
import 'screens/rental_list_screen.dart';
import 'screens/rider_home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/rate_trip_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SurGoApp());
}

/// SurGo — offline UI simulation.
///
/// There is no backend here: every screen reads and writes to an in-memory
/// AppState (see lib/state/app_state.dart) and lib/data/models.dart holds
/// all the mock seed data. It's meant purely to demonstrate what the real
/// app would look and feel like on-device.
class SurGoApp extends StatelessWidget {
  const SurGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SurGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/matching': (context) => const MatchingScreen(),
        '/livetrip': (context) => const LiveTripScreen(),
        '/rental': (context) => const RentalListScreen(),
        '/rider': (context) => const RiderHomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/rate': (context) => const RateTripScreen(),
      },
    );
  }
}

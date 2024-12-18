import 'package:cordon_track_app/presentation/pages/alerts_page.dart';
import 'package:cordon_track_app/presentation/pages/login_page.dart';
import 'package:cordon_track_app/presentation/pages/more_page.dart';
import 'package:cordon_track_app/presentation/pages/onboarding_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/daily_report/daily_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/distance_travelled/distance%20_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/geofence_report/geofence_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/idle_report/idle_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/ignition_report/ignition_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/speed_report/speed_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/stoppage_report/stoppage_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/travelled_path/travelled_path_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/trip_report/trip_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports_page.dart';
import 'package:cordon_track_app/presentation/widgets/custom_nav_bar.dart';
import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final isFirstTime = prefs.getBool('isFirstTime') ?? true; // Default to true
  final hasLoginInfo =
      prefs.containsKey('username') && prefs.containsKey('password');
  runApp(ProviderScope(
      child: (MyApp(
    initialPage: isFirstTime
        ? const OnboardingPage()
        : (hasLoginInfo ? const LoginPage() : const OnboardingPage()),
  ))));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/reportPage': (context) => ReportsPage(),
        '/travelledPath': (context) => const TravelledPathPage(),
        '/distanceReport': (context) => const DistanceReportPage(),
        '/speedReport': (context) => const SpeedReportPage(),
        '/stoppageReport': (context) => const StoppageReportPage(),
        '/idleReport': (context) => const IdleReportPage(),
        '/ignitionReport': (context) => const IgnitionReportPage(),
        '/tripReport': (context) => const TripReportPage(),
        '/dailyReport': (context) => const DailyReportPage(),
        '/geofenceReport': (context) => const GeofenceReportPage(),
        '/loginPage': (context) => const LoginPage(),
        '/navBar': (context) => const CustomNavBar(),
        '/liveMap': (context) => const LiveMapPage(),
        '/alert': (context) => const AlertsPage(),
        '/more': (context) => const MorePage(),
      },
      title: 'Cordon Track',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          // primary: Colors.white,
          // secondary: Colors.white,
          // tertiary: Colors.white
        ),
        useMaterial3: true,
      //  fontFamily: 'Comic Sans Ms',
      ),
      home: initialPage,
      // CustomNavBar(),
    );
  }
}

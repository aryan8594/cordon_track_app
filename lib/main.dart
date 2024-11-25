import 'package:cordon_track_app/presentation/pages/reports/daily%20report/daily_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/distance%20travelled/distance%20_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/idle%20report/idle_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/ignition%20report/ignition_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/speed%20report/speed_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/stoppage%20report/stoppage_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/travelled%20path/travelled_path_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports/trip%20report/trip_report_page.dart';
import 'package:cordon_track_app/presentation/pages/reports_page.dart';
import 'package:cordon_track_app/presentation/widgets/custom_nav_bar.dart';
import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: (MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false, 
      routes: {
      '/reportPage': (context) => ReportsPage(),
      '/travelledPath': (context) => TravelledPathPage(),
      '/distanceReport': (context) => DistanceReportPage(),
      '/speedReport': (context) => SpeedReportPage(),
      '/stoppageReport': (context) => StoppageReportPage(),
      '/idleReport': (context) => IdleReportPage(),
      '/ignitionReport': (context) => IgnitionReportPage(),
      '/tripReport': (context) => TripReportPage(),
      '/dailyReport': (context) => DailyReportPage(),
    },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: CustomNavBar(),
    );
  }
}


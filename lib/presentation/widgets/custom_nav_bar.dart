import 'dart:async';
import 'dart:io';

import 'package:cordon_track_app/data/data_providers/alerts_provider.dart';
import 'package:cordon_track_app/presentation/pages/alerts_page.dart';
import 'package:cordon_track_app/presentation/pages/dashboard_page.dart';
import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:cordon_track_app/presentation/pages/more_page.dart';
import 'package:cordon_track_app/presentation/pages/reports_page.dart';
import 'package:cordon_track_app/presentation/pages/vehicle_search_list.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class CustomNavBar extends ConsumerStatefulWidget {
  const CustomNavBar({super.key});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar> {
  Timer? _alertCheckTimer;

  @override
  void initState() {
    super.initState();
    // Start periodic checks for new alerts when the widget is initialized
    _startAlertCheck();
  }

  void _startAlertCheck() {
    _alertCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.read(newAlertsProvider.notifier).checkForNewAlerts();
      ref.refresh(alertsProvider); // Refresh alertsProvider
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _alertCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final hasNewAlerts =
        ref.watch(newAlertsProvider)?.data?.isNotEmpty ?? false;

    final List<Widget> screens = [
      const DashboardPage(),
      const VehicleSearchList(),
      const LiveMapPage(),
      ReportsPage(),
      MorePage(),
    ];

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return; // Allow the back action if needed.
          }

          // Example: Show confirmation dialog
          final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Exit App?'),
                    content: Text('Do you want to exit the app?\nYou will be logged out?'),
                    actions: [
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pop(true)
                          },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                        child: Text('Exit'),
                      ),
                    ],
                  );
                },
              ) ??
              false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                Image.asset(
                  "lib/presentation/assets/cordon_logo_2.png",
                  height: 25,
                  scale: 10,
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Navigate to AlertsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsPage()),
                  ).then((_) {
                    // Reset notification state after viewing alerts
                    ref.read(newAlertsProvider.notifier).resetAlerts();
                  });
                },
                icon: Icon(
                  hasNewAlerts
                      ? Icons.notifications_active_rounded
                      : Icons.notifications,
                  size: 25,
                  color: hasNewAlerts ? Colors.redAccent : Colors.black87,
                ),
              ),
              const SizedBox(width: 10),
            ],
            leadingWidth: 120,
          ),
          extendBody: true,
          body: screens[currentIndex],
          bottomNavigationBar: Container(
            height: 90,
            padding: const EdgeInsets.all(8),
            child: CustomNavigationBar(
              scaleFactor: 0.1,
              elevation: 9,
              isFloating: true,
              iconSize: 30.0,
              selectedColor: const Color(0xff00AAE5),
              strokeColor: const Color.fromARGB(255, 60, 82, 121),
              unSelectedColor: Colors.white,
              backgroundColor: Colors.black,
              borderRadius: const Radius.circular(20.0),
              items: [
                CustomNavigationBarItem(
                  title: const Text(
                    "Home",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  selectedTitle: const Text(
                    "Home",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 190, 225),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.dashboard_rounded),
                ),
                CustomNavigationBarItem(
                  title: const Text(
                    "Tracking",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  selectedTitle: const Text(
                    "Tracking",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 190, 225),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.airport_shuttle_rounded),
                ),
                CustomNavigationBarItem(
                  title: const Text(
                    "Live Map",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  selectedTitle: const Text(
                    "Live Map",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 190, 225),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.explore_rounded),
                ),
                CustomNavigationBarItem(
                  title: const Text(
                    "Reports",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  selectedTitle: const Text(
                    "Reports",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 190, 225),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.summarize_rounded),
                ),
                CustomNavigationBarItem(
                  title: const Text(
                    "More",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  selectedTitle: const Text(
                    "More",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 190, 225),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
              currentIndex: currentIndex,
              onTap: (index) {
                ref.read(navigationIndexProvider.notifier).state = index;
              },
            ),
          ),
        ));
  }
}

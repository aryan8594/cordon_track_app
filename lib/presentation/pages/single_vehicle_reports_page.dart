import 'dart:async';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/daily_report_provider.dart';
import 'package:cordon_track_app/data/models/reports/daily_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleVehicleReportsPage extends ConsumerStatefulWidget {
  final String vehicleId;
  const SingleVehicleReportsPage({super.key, required this.vehicleId});

  @override
  ConsumerState<SingleVehicleReportsPage> createState() =>
      _SingleVehicleReportsPage();
}

class _SingleVehicleReportsPage
    extends ConsumerState<SingleVehicleReportsPage> {
  Timer? _updateTimer;
  late DateTime fromDate;
  late DateTime toDate;
  DateTime now = DateTime.now();
  @override
  void initState() {
        fromDate =
        DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of the day
    toDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // End of the day
    super.initState();
    ref.read(dailyReportProvider.notifier).fetchDailyReport(
              id: widget.vehicleId,
              fromDate: fromDate,
              toDate: toDate,
            );
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    fromDate =
        DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of the day
    toDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // End of the day
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        ref.read(dailyReportProvider.notifier).fetchDailyReport(
              id: widget.vehicleId,
              fromDate: fromDate,
              toDate: toDate,
            );
      }
    });
  }

  String convertSecondsToHoursMinutes(String secondsString) {
    // Convert the string to an integer
    int totalSeconds = int.parse(secondsString) ?? 0;

    // Create a Duration object
    Duration duration = Duration(seconds: totalSeconds);

    // Extract hours and minutes
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    // Return formatted string
    return '${hours}h ${minutes}m';
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final dailyReport = ref.read(dailyReportProvider);
    return _buildContent();
  }

  Widget _buildContent() {
    final dailyReport = ref.watch(dailyReportProvider);

    String calculateDifference(double value1, double value2) {
      double difference = value1 - value2;
      return difference.toStringAsFixed(2);
    }

    return dailyReport.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(
              child: Text("No data available for this vehicle."));
        }

        var vehicleInfo =
            vehicle.data![0]; // Access the first item in the data list
        // double? speed = vehicleInfo.speed != null
        //     ? double.tryParse(vehicleInfo.speed!)
        //     : null;

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Today Overview",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Distance",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                                "${calculateDifference(vehicleInfo.odometerEnd?.toDouble() ?? 0, vehicleInfo.odometerStart?.toDouble() ?? 0)} kms")
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Travel Time",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                                "${convertSecondsToHoursMinutes(vehicleInfo.runningTime!)}")
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Stoppage Time",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                                "${convertSecondsToHoursMinutes(vehicleInfo.stoppageTime!)}")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Average Speed",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text("${vehicleInfo.avgSpeed} km/h")
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Max Speed",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text("${(vehicleInfo.maxSpeed!)} km/h")
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Odometer\nReading",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "${(vehicleInfo.odometerEnd!)} kms",
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Error: $err"),
    );
  }

  Widget _buildInfoCard(String title, String value,
      {bool isSmallText = false}) {
    return Card(
      color: Colors.white70,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              value,
              style: TextStyle(fontSize: isSmallText ? 13 : null),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cordon_track_app/data/data_providers/reports/daily_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/distance_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/travelled_path_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyReportResult extends ConsumerStatefulWidget {
  const DailyReportResult({Key? key}) : super(key: key);

  @override
  ConsumerState<DailyReportResult> createState() => _DailyReportResultState();
}

class _DailyReportResultState extends ConsumerState<DailyReportResult> {
  @override
  Widget build(BuildContext context) {
    final dailyReport = ref.watch(dailyReportProvider);
    String convert1000Format(String input) {
      // Parse the string to an integer
      int number = int.tryParse(input) ?? 0;
      // Divide by 1000 and omit decimals
      int result = number ~/ 1000;
      // Convert back to a string
      return result.toString();
    }

    String formatSecondsToTime(int seconds) {
      int hours = seconds ~/ 3600; // Calculate the hours
      int minutes = (seconds % 3600) ~/ 60; // Calculate the remaining minutes
      return "${hours} hr ${minutes} min";
    }

      String convertSecondsToHoursMinutes(String secondsString) {
  // Convert the string to an integer
  int totalSeconds = int.tryParse(secondsString) ?? 0;

  // Create a Duration object
  Duration duration = Duration(seconds: totalSeconds);

  // Extract hours and minutes
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  // Return formatted string
  return '${hours}h ${minutes}m';
}

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Report")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: dailyReport.when(
          data: (data) {
            if (data == null || data.data!.isEmpty) {
              return const Center(
                child: Text("No data available."),
              );
            }

            // Display each data item in a Card
            return SingleChildScrollView(
              child: Column(
                children: data.data!.map((item) {
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Number: ${item.rto}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Report Date: ${item.date}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("Ignition Start: ${item.ignitionStart}"),
                          const SizedBox(height: 8),
                          Text("Ignition End: ${item.ignitionEnd}"),
                          const SizedBox(height: 8),
                          Text("Location Start: ${item.locationStart}"),
                          const SizedBox(height: 8),
                          Text("Location End: ${item.locationEnd}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "Odometer range : ${item.odometerStart}kms - ${item.odometerEnd}kms",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Average Speed: ${item.avgSpeed} km/h"),
                          const SizedBox(height: 8),
                          Text("Maximum Speed: ${item.maxSpeed} km/h"),
                          const SizedBox(height: 8),
                          Text("Total Run Time: ${convertSecondsToHoursMinutes(item.runningTime!)}"),
                          const SizedBox(height: 8),
                          Text("Total Idle Time: ${convertSecondsToHoursMinutes(item.idleTime!)}"),
                          const SizedBox(height: 8),
                          Text("Total Stoppage Time: ${convertSecondsToHoursMinutes(item.stoppageTime!)}"),
                          const SizedBox(height: 8),
                          // Add more fields as necessary
                          //           "avg_speed": "23.6322",
                          // "max_speed": "41",
                          //           "running_time": "1043",
                          // "idle_time": "329",
                          // "stoppage_time": "14926",
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text("Error: $error"),
          ),
        ),
      ),
    );
  }
}

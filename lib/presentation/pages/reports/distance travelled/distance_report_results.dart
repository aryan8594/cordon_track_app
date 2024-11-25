import 'package:cordon_track_app/data/data_providers/reports/distance_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/travelled_path_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DistanceReportResult extends ConsumerStatefulWidget {
  const DistanceReportResult({Key? key}) : super(key: key);

  @override
  ConsumerState<DistanceReportResult> createState() => _DistanceReportResultState();
}

class _DistanceReportResultState extends ConsumerState<DistanceReportResult> {
  @override
  Widget build(BuildContext context) {
    final distanceReport = ref.watch(distanceReportProvider);
    String convert1000Format(String input) {
  // Parse the string to an integer
  int number = int.tryParse(input) ?? 0;
  // Divide by 1000 and omit decimals
  int result = number ~/ 1000;
  // Convert back to a string
  return result.toString();
}


    return Scaffold(
  appBar: AppBar(title: const Text("Distance Report")),
  body: Padding(
    padding: const EdgeInsets.all(5),
    child: distanceReport.when(
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text("Distance Convered: ${item.distance} kms",
                      style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 8),
                      Text("Location Start: ${item.locationStart}"),
                      const SizedBox(height: 8),
                      Text("Location End: ${item.locationEnd}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("Odometer range : ${item.odometerStart}kms - ${item.odometerEnd}kms" ,
                          style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      )
                      // Add more fields as necessary
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

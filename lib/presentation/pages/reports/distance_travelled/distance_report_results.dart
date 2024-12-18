import 'package:cordon_track_app/data/data_providers/reports/distance_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DistanceReportResult extends ConsumerStatefulWidget {
  const DistanceReportResult({super.key});

  @override
  ConsumerState<DistanceReportResult> createState() => _DistanceReportResultState();
}

class _DistanceReportResultState extends ConsumerState<DistanceReportResult> {
  @override
  Widget build(BuildContext context) {
    final distanceReport = ref.watch(distanceReportProvider);
//     String convert1000Format(String input) {

//   int number = int.tryParse(input) ?? 0;

//   int result = number ~/ 1000;

//   return result.toString();
// }


    return Scaffold(
      //colorScheme.secondary,
  appBar: AppBar(
    //colorScheme.primary,
    title: const Text("Distance Report")),
  body: Padding(
    padding: const EdgeInsets.all(5),
    child: distanceReport.when(
  data: (data) {
    final items = data.data ?? [];
    if (items.isEmpty) {
      return const Center(
        child: Text("No data available."),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle Number: ${item.rto  ?? "Not Available"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Distance Covered: ${item.distance  ?? "Not Available"} kms",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Location Start: ${item.locationStart  ?? "Not Available"}"),
                const SizedBox(height: 8),
                Text("Location End: ${item.locationEnd  ?? "Not Available"} "),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Odometer range: ${item.odometerStart} kms - ${item.odometerEnd} kms",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  },
  loading: () => const Center(
    child: CircularProgressIndicator(),
  ),
  error: (error, stack) => Center(
    child: Text("Error: $error"),
  ),
),
  )
);


  }
}

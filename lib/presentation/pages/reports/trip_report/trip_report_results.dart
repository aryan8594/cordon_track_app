import 'package:cordon_track_app/data/data_providers/reports/ignition_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/travelled_path_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/trip_report_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TripReportResult extends ConsumerStatefulWidget {
  const TripReportResult({super.key});


  @override
  ConsumerState<TripReportResult> createState() => _TripReportResultState();
}

class _TripReportResultState extends ConsumerState<TripReportResult> {
  @override
  Widget build(BuildContext context) {
    final tripReport = ref.watch(tripReportProvider);
    String formatSecondsToTime(int seconds) {
  int hours = seconds ~/ 3600; // Calculate the hours
  int minutes = (seconds % 3600) ~/ 60; // Calculate the remaining minutes
  return "${hours} hr ${minutes} min";
}


    return Scaffold(
      appBar: AppBar(title: const Text("Trips Report")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: tripReport.when(
          data: (data) {
            if (data == null || data.data!.isEmpty) {
              return const Center(
                child: Text("No data available."),
              );
            }

            // Build a single DataTable with all rows
            return DataTable2(
              dataRowHeight:150,
              smRatio: 0.5,
          horizontalMargin: 12,
          minWidth: 600,
              // dataRowMaxHeight: 100,
              columnSpacing: 5,
              clipBehavior: Clip.hardEdge,
              columns: const [
                DataColumn(
                  label: Text('Start\nDate Time'),
                ),
                DataColumn(
                  label: Text('Start\nLocation'),
                ),
                DataColumn(
                  label: Text('End\nDate Time'),
                ),
                DataColumn(
                  label: Text('End\nLocation'),
                ),
                DataColumn(
                  label: Text('Duration'),
                ),
                DataColumn(
                  label: Text('Distance'),
                ),
              ],
              rows: data.data!
                  .map(
                    (item) => DataRow(
                      
                      cells: [
                        DataCell(Text('${item.startDatetime}')),
                        DataCell(Text('${item.startLocation}')),
                        DataCell(Text('${item.endDatetime}')),
                        DataCell(Text('${item.endLocation}')),
                        DataCell(Text('${formatSecondsToTime(item.duration!)}')),
                        DataCell(Text('${item.distance} km')),
                      ],
                    ),
                  )
                  .toList(),
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

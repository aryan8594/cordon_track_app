import 'package:cordon_track_app/data/data_providers/reports/idle_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/stoppage_report_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/travelled_path_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdleReportResult extends ConsumerStatefulWidget {
  const IdleReportResult({Key? key}) : super(key: key);

  @override
  ConsumerState<IdleReportResult> createState() =>
      _IdleReportResultState();
}

class _IdleReportResultState extends ConsumerState<IdleReportResult> {
  @override
  Widget build(BuildContext context) {
    final idleReport = ref.watch(idleReportProvider);

    String formatSecondsToTime(int seconds) {
  int hours = seconds ~/ 3600; // Calculate the hours
  int minutes = (seconds % 3600) ~/ 60; // Calculate the remaining minutes
  return "${hours} hr ${minutes} min";
}


    return Scaffold(
      appBar: AppBar(title: const Text("Idle Report")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: idleReport.when(
          data: (data) {
            if (data == null || data.data!.isEmpty) {
              return const Center(
                child: Text("No data available."),
              );
            }

            // Build a single DataTable with all rows
            return DataTable2(
              dataRowHeight: 100,
              smRatio: 0.5,
              horizontalMargin: 12,
              minWidth: 300,
              // dataRowMaxHeight: 100,
              columnSpacing: 5,
              clipBehavior: Clip.hardEdge,
              columns: const [
                DataColumn(
                  label: Text('From\nDate Time'),
                ),
                DataColumn(
                  label: Text('To\nDate Time'),
                ),
                DataColumn(
                  label: Text('Duration'),
                ),
                DataColumn(
                  label: Text('Location'),
                ),
              ],
              rows: data.data!
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text('${item.startDatetime}')),
                        DataCell(Text('${item.endDatetime}')),
                        DataCell(Text('${formatSecondsToTime(item.stoppageTime!)}')),
                        DataCell(Text('${item.location}')),
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

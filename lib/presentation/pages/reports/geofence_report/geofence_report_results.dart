import 'package:cordon_track_app/data/data_providers/reports/geofence_report_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GeofenceReportResult extends ConsumerStatefulWidget {
  final String type;
  const GeofenceReportResult({super.key, required this.type});


  @override
  ConsumerState<GeofenceReportResult> createState() => _GeofenceReportResultState();
}

class _GeofenceReportResultState extends ConsumerState<GeofenceReportResult> {
  @override
  Widget build(BuildContext context) {
    final geofenceReport = ref.watch(geofenceReportProvider);
    String formatSecondsToTime(int seconds) {
  int hours = seconds ~/ 3600; // Calculate the hours
  int minutes = (seconds % 3600) ~/ 60; // Calculate the remaining minutes
  return "${hours} hr ${minutes} min";
}


    return Scaffold(
      appBar: AppBar(title: Text("Geofence Report: ${widget.type}")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: geofenceReport.when(
          data: (data) {
            if (data == null || data.data!.history!.isEmpty) {
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
                  label: Text('Vehicle RTO'),
                ),
                DataColumn(
                  label: Text('Geofence\nIn Time'),
                ),
                DataColumn(
                  label: Text('Geofence\nOut Time'),
                ),
                DataColumn(
                  label: Text('Geofence\nName'),
                ),
                DataColumn(
                  label: Text('Duration'),
                ),
                DataColumn(
                  label: Text('Distance'),
                ),
              ],
              rows: data.data!.history!
                  .map(
                    (item) => DataRow(
                      
                      cells: [
                        DataCell(Text('${item.rto}')),
                        DataCell(Text('${item.inDatetime}')),
                        DataCell(Text('${item.outDatetime}')),
                        DataCell(Text('${item.geoName}')),
                        DataCell(Text('${item.duration ?? 0} ')),
                        DataCell(Text('${(item.distance?.toDouble())} km')),
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

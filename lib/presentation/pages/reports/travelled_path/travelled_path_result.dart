import 'package:cordon_track_app/data/data_providers/reports/travelled_path_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelledPathResult extends ConsumerStatefulWidget {
  const TravelledPathResult({super.key});

  @override
  ConsumerState<TravelledPathResult> createState() =>
      _TravelledPathResultState();
}

class _TravelledPathResultState extends ConsumerState<TravelledPathResult> {
  @override
  Widget build(BuildContext context) {
    final travelledPathState = ref.watch(travelledPathProvider);
    String convert1000Format(String input) {
      // Parse the string to an integer
      int number = int.tryParse(input) ?? 0;
      // Divide by 1000 and omit decimals
      int result = number ~/ 1000;
      // Convert back to a string
      return result.toString();
    }

    return Scaffold(
      // backgroundColor: Theme.of(context).//colorScheme.secondary,
      appBar: AppBar(
          // backgroundColor: Theme.of(context).//colorScheme.primary,
          title: const Text("Travelled Path Report")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: travelledPathState.when(
          data: (data) {
            // ignore: unnecessary_null_comparison
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
                  label: Text('Date Time'),
                ),
                DataColumn(
                  label: Text('Odometer'),
                ),
                DataColumn(
                  label: Text('Speed'),
                ),
                DataColumn(
                  label: Text('Location'),
                ),
              ],
              rows: data.data!
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item.datetime ?? "Not Available")),
                        DataCell(Text(
                            '${convert1000Format(item.acumulatedDistance!)} km')),
                        DataCell(Text('${item.speed ?? "Not Available"} km/h')),
                        DataCell(Text(item.location ?? "Not Available")),
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

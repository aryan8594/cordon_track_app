// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:cordon_track_app/business_logic/search_query_provider.dart';
import 'package:cordon_track_app/data/data_providers/reports/stoppage_report_provider.dart';
import 'package:cordon_track_app/presentation/pages/reports/stoppage_report/stoppage_report_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoppageReportPage extends ConsumerStatefulWidget {
  const StoppageReportPage({super.key});

  @override
  _StoppageReportState createState() => _StoppageReportState();
}

class _StoppageReportState extends ConsumerState<StoppageReportPage> {
  DateTime today = DateTime.now();
  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  DateTime toDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  String? timeDifference;
  String selectedRange = 'Today';
  String? vehicleID;
  String? vehicleName;

  @override
  Widget build(BuildContext context) {
    // final stoppageReport = ref.watch(stoppageReportProvider);

    return Scaffold(
      //colorScheme.secondary,
      appBar: AppBar(
        //colorScheme.primary,
        title: const Text("Stoppage Report"),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10), child: Container()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(
          builder: (context, ref, child) {
            final query = ref.watch(searchQueryProvider);
            final filteredVehicles = ref.watch(filteredVehiclesProvider);
            final textController = TextEditingController(text: query);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Search Field for Vehicles
                  TextField(
                    decoration: InputDecoration(
                      labelText:
                          vehicleID != null ? vehicleName : 'Search Vehicle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (newQuery) {
                      // Update the search query in the provider
                      ref.read(searchQueryProvider.notifier).state = newQuery;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Vehicle Dropdown (Visible only when there is a query)
                  if (query.isNotEmpty)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: filteredVehicles.isEmpty
                          ? const Center(
                              child: Text("No vehicles found."),
                            )
                          : ListView.builder(
                              itemCount: filteredVehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle = filteredVehicles[index];
                                return ListTile(
                                  title: Text(vehicle.rto ?? 'Unknown RTO'),
                                  // subtitle: Text('Vehicle ID: ${vehicle.id}'),
                                  onTap: () {
                                    // Populate the search text field with the RTO
                                    vehicleName = vehicle.rto ?? '';
                                    textController.text =
                                        vehicle.rto ?? ''; // Update text field
                                    // Update the selected vehicle ID
                                    vehicleID = vehicle.id.toString();
                                    log('Selected vehicle ID: $vehicleID');
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .state = '';
                                  },
                                );
                              },
                            ),
                    ),
                  const SizedBox(height: 8),
                  // Time Difference Input Field
                  DropdownButtonFormField<String>(
                    value: timeDifference, // Bind the currently selected value
                    decoration: InputDecoration(
                      labelText: 'Stoppage Time filter',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: '0',
                        child: Text('None'),
                      ),
                      DropdownMenuItem(
                        value: '120',
                        child: Text('More than 2 Minute'),
                      ),
                      DropdownMenuItem(
                        value: '600',
                        child: Text('More than 10 minutes'),
                      ),
                      DropdownMenuItem(
                        value: '1200',
                        child: Text('More than 20 minutes'),
                      ),
                      DropdownMenuItem(
                        value: '2400',
                        child: Text('More than 40 minutes'),
                      ),
                      DropdownMenuItem(
                        value: '3600',
                        child: Text('More than 1 hour'),
                      ),
                      DropdownMenuItem(
                        value: '7200',
                        child: Text('More than 2 hours'),
                      ),
                      DropdownMenuItem(
                        value: '10800',
                        child: Text('More than 3 hours'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        timeDifference =
                            value; // Update the timeDifference when a selection is made
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  // Date Range Selector
                  InkWell(
                    onTap: () => showDateRangeSelectionSheet(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            selectedRange,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Icon(Icons.date_range),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Fetch Data Button
                  ElevatedButton(
                    onPressed: () async {
                      if (vehicleID != null) {
                        ref
                            .read(stoppageReportProvider.notifier)
                            .fetchStoppageReport(
                              id: vehicleID!, // Use selected vehicle ID
                              fromDate: fromDate,
                              toDate: toDate,
                              time: timeDifference ?? "",
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoppageReportResult()),
                        );
                      } else {
                        log("Missing vehicle ID or date range");
                      }
                    },
                    child: const Text("Fetch Stoppage Report", style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showDateRangeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            // TODAY
            ListTile(
              title: const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                setState(() {
                  fromDate =
                      DateTime(today.year, today.month, today.day, 0, 0, 0);
                  toDate =
                      DateTime(today.year, today.month, today.day, 23, 59, 59);
                  selectedRange = 'Today';
                });
                Navigator.pop(context);
                // ref.read(travelledPathProvider.notifier).fetchTravelledPath(
                //       id: "43148",
                //       fromDate: fromDate!,
                //       toDate: toDate!,
                //       timeDifference: "120",
                //     );
              },
            ),
            // YESTERDAY
            ListTile(
              title: const Text(
                'Yesterday',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final yesterday =
                    DateTime.now().subtract(const Duration(days: 1));
                setState(() {
                  fromDate = DateTime(
                      yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
                  toDate = DateTime(yesterday.year, yesterday.month,
                      yesterday.day, 23, 59, 59);
                  selectedRange = 'Yesterday';
                });
                Navigator.pop(context);
                // ref.read(travelledPathProvider.notifier).fetchTravelledPath(
                //       id: "43148",
                //       fromDate: fromDate!,
                //       toDate: toDate!,
                //       timeDifference: "120",
                //     );
              },
            ),
            // THIS WEEK
            ListTile(
              title: const Text(
                'This Week',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                setState(() {
                  fromDate = DateUtil.startOfWeek();
                  toDate = DateUtil.startOfWeek().add(const Duration(days: 7));
                  selectedRange = 'This Week';
                });
                Navigator.pop(context);
                // ref.read(travelledPathProvider.notifier).fetchTravelledPath(
                //       id: "43148",
                //       fromDate: fromDate!,
                //       toDate: toDate!,
                //       timeDifference: "120",
                //     );
              },
            ),
            // LAST WEEK
            ListTile(
              title: const Text(
                'Last Week',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                setState(() {
                  fromDate =
                      DateUtil.startOfWeek().subtract(const Duration(days: 7));
                  toDate = fromDate.add(const Duration(days: 7));
                  selectedRange = 'Last Week';
                });
                Navigator.pop(context);
                // ref.read(travelledPathProvider.notifier).fetchTravelledPath(
                //       id: "43148",
                //       fromDate: fromDate!,
                //       toDate: toDate!,
                //       timeDifference: "120",
                //     );
              },
            ),
            // LAST 7 DAYS
            ListTile(
              title: const Text(
                'Last 7 Days',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                setState(() {
                  fromDate =
                      DateTime(today.year, today.month, today.day, 0, 0, 0)
                          .subtract(const Duration(days: 7));
                  toDate =
                      DateTime(today.year, today.month, today.day, 23, 59, 59);
                  selectedRange = 'Last 7 Days';
                });
                Navigator.pop(context);
                // ref.read(travelledPathProvider.notifier).fetchTravelledPath(
                //       id: "43148",
                //       fromDate: fromDate!,
                //       toDate: toDate!,
                //       timeDifference: "120",
                //     );
              },
            ),
            // CUSTOM DATE PICKER
            ListTile(
              title: const Text(
                'Custom Range',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                Navigator.pop(context);
                selectedRange = 'Custom DateTime Range';
                final pickedDates = await showBoardDateTimeMultiPicker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  minimumDate: DateTime.now().subtract(const Duration(days: 7)),
                  maximumDate: DateTime.now(),
                  startDate: fromDate,
                  endDate: toDate,
                  options: const BoardDateTimeOptions(
                    languages: BoardPickerLanguages.en(),
                    startDayOfWeek: DateTime.sunday,
                    pickerFormat: PickerFormat.ymd,
                    // topMargin: 0,
                  ),
                  headerWidget: Container(
                    height: 80,
                    margin: const EdgeInsets.all((8)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(color: Colors.blueAccent, width: 4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Select Date-Range\n(YYYY/MM/DD HH:MM)  ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                    ),
                  ),
                );

                if (pickedDates != null) {
                  fromDate = pickedDates.start;
                  toDate = pickedDates.end;
                  ref.read(stoppageReportProvider.notifier).fetchStoppageReport(
                        id: vehicleID!,
                        fromDate: fromDate,
                        toDate: toDate,
                        time: timeDifference!,
                      );
                  log("dates selected $pickedDates");
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class DateUtil {
  static DateTime startOfWeek() {
    final today = DateTime.now();
    final firstDayWeek = DateTime(today.year, today.month, today.day, 0, 0, 0);
    return firstDayWeek.subtract(Duration(days: today.weekday - 1));
  }

  static DateTime endOfWeek() {
    final today = DateTime.now();
    final firstDayWeek =
        DateTime(today.year, today.month, today.day, 23, 59, 59);
    return firstDayWeek.subtract(Duration(days: today.weekday + 5));
  }
}

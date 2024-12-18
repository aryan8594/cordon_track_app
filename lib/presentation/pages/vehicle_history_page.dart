// ignore_for_file: unused_local_variable

import 'dart:developer';
// import 'dart:math';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/playback_timer_provider.dart';
import 'package:cordon_track_app/business_logic/poly_line_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    as riverpod; // Use alias

class VehicleHistoryPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleHistoryPage({required this.vehicleId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VehicleHistoryPageState createState() => _VehicleHistoryPageState();
}

class _VehicleHistoryPageState extends ConsumerState<VehicleHistoryPage> {
  DateTime? fromDate;
  DateTime? toDate;
  String selectedRange = 'Today';
  bool isLoading = false; // Track loading state
  int timerMultiplier = 1; // Default to 1x speed
  late MapControllerNotifier mapControllerNotifier;

  @override
  void initState() {
    super.initState();

    mapControllerNotifier = ref.read(mapControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () async {
        final today = DateTime.now();
        fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0);
        toDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
        selectedRange = 'Today';
        loadPolylinesWithCustomDates();
      });
    });
  }

  Future<void> loadPolylinesWithCustomDates() async {
    if (mounted) {
      setState(() {
        isLoading = true; // Start loading
      });

      if (fromDate != null && toDate != null) {
        await ref
            .read(polyLineProvider(widget.vehicleId).notifier)
            .loadVehicleHistoryPolylineMarkers(
              widget.vehicleId,
              fromDate!,
              toDate!,
            );
      }

      final polylineState = ref.read(polyLineProvider(widget.vehicleId));
      if (polylineState.polylineCoordinates.isNotEmpty) {
        final firstPosition = polylineState.polylineCoordinates.first;
        ref.read(mapControllerProvider.notifier).animateCamera(
              CameraUpdate.newLatLng(
                LatLng(firstPosition.latitude, firstPosition.longitude),
              ),
            );
      }

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false; // End loading
        });
      });
    }
  }

  void updateMultiplier(int multiplier) {
    setState(() {
      timerMultiplier = multiplier;
    });

    // Update playbackTimerProvider with the new multiplier
    ref.read(playbackTimerProvider.notifier).setSpeedMultiplier(multiplier);
  }

  @override
  void dispose() {
    // ref.read(polyLineProvider(widget.vehicleId).notifier).pausePlayback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final polylineState = ref.watch(polyLineProvider(widget.vehicleId));
    final polylineNotifier =
        ref.read(polyLineProvider(widget.vehicleId).notifier);
    final playbackTimer = ref.read(playbackTimerProvider.notifier);

    final Set<Marker> allMarkers = {
      ...polylineState.markers,
      if (polylineState.playbackMarker != null) polylineState.playbackMarker!,
    };

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            showDateRangeSelectionSheet(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  selectedRange,
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
              ),
              riverpod.Consumer(
                builder: (context, ref, _) {
                  // Get the current state of historyVehicleProvider
                  final historyData = ref.watch(historyVehicleProvider);

                  if (historyData == null) {
                    return const Text(
                      "Loading...",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.end,
                    );
                  }

                  // Extract the distance from the history data
                  final distance = historyData.data?.distance;

                  return Text(
                    distance != null
                        ? "Distance Covered: ${distance.toStringAsFixed(2)} km"
                        : "Distance Covered: No Data",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  );
                },
              ),
              const Icon(Icons.date_range),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(12.976692, 77.576249),
                    zoom: 11,
                  ),
                  onMapCreated: (controller) async {
                    await mapControllerNotifier
                        .initializeController(controller);
                    // ignore: deprecated_member_use
                    controller.setMapStyle(Utils.mapStyles);
                    controller
                        .showMarkerInfoWindow(const MarkerId('playbackMarker'));
                  },
                  markers: allMarkers,
                  polylines: polylineState.polylines,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: false,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70,
                ),
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Timer Multiplier Dropdown
                        DropdownButton<int>(
                          value: timerMultiplier,
                          items: [1, 2, 3, 5, 10]
                              .map(
                                (multiplier) => DropdownMenuItem<int>(
                                  value: multiplier,
                                  child: Text("${multiplier}x"),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              updateMultiplier(value);
                            }
                          },
                        ),

                        // Playback Slider
                        Expanded(
                          child: Slider(
                            activeColor: Colors.blueAccent,
                            value: polylineState.currentIndex.toDouble(),
                            min: 0,
                            max: polylineState.polylineCoordinates.isNotEmpty
                                ? (polylineState.polylineCoordinates.length - 1)
                                    .toDouble()
                                : 0,
                            onChanged: (value) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() <
                                      polylineState
                                          .polylineCoordinates.length) {
                                polylineNotifier.setCurrentIndex(value.toInt());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Backward Seek Button
                        IconButton(
                          icon: const Icon(Icons.fast_rewind),
                          iconSize: 30,
                          onPressed: () {
                            ref
                                .read(playbackTimerProvider.notifier)
                                .seekBackward();
                          },
                        ),

                        // Play/Pause Button
                        IconButton(
                          iconSize: 30,
                          icon: Icon(polylineState.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            polylineNotifier.togglePlayPause();
                            if (polylineNotifier.isPlaying) {
                              ref
                                  .read(playbackTimerProvider.notifier)
                                  .startPlayback(widget.vehicleId);
                            } else {
                              ref
                                  .read(playbackTimerProvider.notifier)
                                  .stopPlayback();
                            }
                          },
                        ),

                        // Forward Seek Button
                        IconButton(
                          icon: const Icon(Icons.fast_forward),
                          iconSize: 30,
                          onPressed: () {
                            ref
                                .read(playbackTimerProvider.notifier)
                                .seekForward();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          // Positioned(
          //   bottom: 100,
          //   left: 10,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       // final historyData = vehicleHistory;
          //       // final historyOdoStart =
          //       //     historyData?.data?.odometerStart?.toString() ??
          //       //         "No Data Available";
          //       // final historyOdoEnd =
          //       //     historyData?.data?.odometerEnd?.toString() ??
          //       //         "No Data Available";
          //       // final historyDistance =
          //       //     historyData?.data?.distance?.toString() ??
          //       //         "No Data Available";
          //       // print("vehicleHistory: ${vehicleHistory}");
          //       // print("Odometer Start: ${vehicleHistory?.data?.odometerStart}");
          //       // print("Odometer End: ${vehicleHistory?.data?.odometerEnd}");
          //       // print("Distance: ${vehicleHistory?.data?.distance}");
          //       // showDialog(
          //       //     context: context,
          //       //     builder: (context) {
          //       //       return AlertDialog(
          //       //         title: const Icon(
          //       //           Icons.message,
          //       //           color: Color.fromRGBO(144, 202, 220, 1),
          //       //           size: 35.0,
          //       //           semanticLabel:
          //       //               'Info Window for Vehile History Data for slected Range.',
          //       //         ),
          //       //         content: Container(
          //       //           height: 50,
          //       //           child: Column(
          //       //             children: [
          //       //               Text(
          //       //                   'Total Distance covered for the Selected Range: ${historyDistance}'),
          //       //             ],
          //       //           ),
          //       //         ),
          //       //         actions: <Widget>[
          //       //           TextButton(
          //       //               onPressed: () => Navigator.of(context).pop(),
          //       //               child: Text('OK')),
          //       //         ],
          //       //       );
          //       //     });
          //     },
          //     child: const Icon(Icons.info),
          //   ),
          // )
        ],
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
            //TODAY
            ListTile(
              title: const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                fromDate =
                    DateTime(today.year, today.month, today.day, 0, 0, 0);
                toDate =
                    DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Today';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //YESTERDAY
            ListTile(
              title: const Text(
                'Yesterday',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final yesterday =
                    DateTime.now().subtract(const Duration(days: 1));
                fromDate = DateTime(
                    yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
                toDate = DateTime(
                    yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
                selectedRange = 'Yesterday';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //THIS WEEK
            ListTile(
              title: const Text(
                'This Week',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateUtil.startOfWeek();
                toDate = DateUtil.startOfWeek().add(const Duration(days: 7));
                selectedRange = 'This Week';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST WEEK
            ListTile(
              title: const Text(
                'Last Week',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                fromDate =
                    DateUtil.startOfWeek().subtract(const Duration(days: 7));
                toDate = fromDate!.add(const Duration(days: 7));
                selectedRange = 'Last Week';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST 7 DAYS
            ListTile(
              title: const Text(
                'Last 7 Days',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0)
                    .subtract(const Duration(days: 7));
                toDate =
                    DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Last 7 Days';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            // //LAST 15 DAYS
            // ListTile(
            //   title: const Text(
            //     'Last 15 Days',
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   onTap: () {
            //     final today = DateTime.now();
            //     fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0)
            //         .subtract(const Duration(days: 15));
            //     toDate =
            //         DateTime(today.year, today.month, today.day, 23, 59, 59);
            //     selectedRange = 'Last 15 Days';
            //     Navigator.pop(context);
            //     loadPolylinesWithCustomDates();
            //   },
            // ),
            // //THIS MONTH
            // ListTile(
            //   title: const Text(
            //     'This Month',
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   onTap: () {
            //     final today = DateTime.now();
            //     fromDate = DateUtil.startOfMonth();
            //     toDate = fromDate!.add(const Duration(days: 30));
            //     selectedRange = 'This Month';
            //     Navigator.pop(context);
            //     loadPolylinesWithCustomDates();
            //   },
            // ),
            // //LAST MONTH
            // ListTile(
            //   title: const Text(
            //     'Last Month',
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   onTap: () {
            //     final today = DateTime.now();
            //     fromDate =
            //         DateUtil.startOfMonth().subtract(const Duration(days: 30));
            //     toDate = fromDate!.add(const Duration(days: 30));
            //     selectedRange = 'Last Month';
            //     Navigator.pop(context);
            //     loadPolylinesWithCustomDates();
            //   },
            // ),
            // //LAST 30 DAYS
            // ListTile(
            //   title: const Text(
            //     'Last 30 Days',
            //     style: TextStyle(fontWeight: FontWeight.w500),
            //   ),
            //   onTap: () {
            //     final today = DateTime.now();
            //     fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0)
            //         .subtract(const Duration(days: 30));
            //     toDate =
            //         DateTime(today.year, today.month, today.day, 23, 59, 59);
            //     selectedRange = 'Last 30 Days';
            //     Navigator.pop(context);
            //     loadPolylinesWithCustomDates();
            //   },
            // ),
            //CUSTOM DATE PICKER
            ListTile(
              title: const Text(
                'Custom Range',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                Navigator.pop(context);
                selectedRange = 'Custom Range';
                final pickedDates = await showBoardDateTimeMultiPicker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  minimumDate: DateTime.now().subtract(const Duration(days: 8)),
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
                  Future.microtask(() {
                    loadPolylinesWithCustomDates();
                  });
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

  static DateTime startOfMonth() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, 1, 0, 0, 0);
  }

  static DateTime endOfMonth() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, 30, 23, 59, 59);
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#def2ff"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}

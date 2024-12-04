import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:cordon_track_app/data/data_providers/reports/daily_report_provider.dart';
import 'package:cordon_track_app/data/models/reports/daily_report_model.dart';
import 'package:intl/intl.dart';
import 'package:backdrop/backdrop.dart';
import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/poly_line_provider.dart';
import 'package:cordon_track_app/business_logic/single_marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleVehicleMapPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const SingleVehicleMapPage({super.key, required this.vehicleId});

  @override
  ConsumerState<SingleVehicleMapPage> createState() =>
      _SingleVehicleMapPageState();
}

class _SingleVehicleMapPageState extends ConsumerState<SingleVehicleMapPage> {
  Timer? _updateTimer;
  final _backdropKey = GlobalKey<BackdropScaffoldState>();
  double _dragOffset = 0.0;
  bool _isBackLayerVisible = false;
  late MapControllerNotifier mapControllerNotifier;
  String savedLat = "";
  String savedLong = "";
//  DateTime now = DateTime.now();

  // DateTime fromDate = DateTime.now().subtract(Duration(days: 1));
  // DateTime toDate = DateTime.now();

  Set<Polyline> polylines = {};

  DateTime now = DateTime.now();
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime fromDatePoly;

  @override
  void initState() {
    super.initState();
    mapControllerNotifier = ref.read(mapControllerProvider.notifier);
    fromDatePoly = now.subtract(const Duration(minutes: 30));
    fromDate =
        DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of the day
    toDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // End of the day

    Future.microtask(() {
      loadPolylinesWithCustomDates();
      ref.read(dailyReportProvider.notifier).fetchDailyReport(
            id: widget.vehicleId,
            fromDate: fromDate,
            toDate: toDate,
          );
    });
    ref
        .read(singleMarkerProvider(widget.vehicleId).notifier)
        .updateMarkers(context);
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        // Update from and to dates for the refresh
        DateTime now = DateTime.now();
        DateTime fromDatePoly = now.subtract(const Duration(minutes: 30));
        fromDate =
            DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of the day
        DateTime toDate = DateTime(
            now.year, now.month, now.day, 23, 59, 59); // End of the day

        // Clear polylines and reload with new data
        Future.microtask(() {
          loadPolylinesWithCustomDates();

          if (mounted) {
            ref
                .read(singleMarkerProvider(widget.vehicleId).notifier)
                .updateMarkers(context);

            ref.read(dailyReportProvider.notifier).fetchDailyReport(
                  id: widget.vehicleId,
                  fromDate: fromDate,
                  toDate: toDate,
                );
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void loadPolylinesWithCustomDates() {
    if (fromDate != null && toDate != null) {
      ref
          .read(polyLineProvider(widget.vehicleId).notifier)
          .loadVehicleHistoryPolylineMarkers(
              widget.vehicleId, fromDatePoly!, toDate!);
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    if (!mounted) {
      ref.read(mapControllerProvider.notifier).disposeController();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(singleLiveVehicleProvider(widget.vehicleId));
    final markers = ref.watch(singleMarkerProvider(widget.vehicleId));
    polylines = ref.watch(polylineStateProvider(widget.vehicleId));
    return BackdropScaffold(
      key: _backdropKey,
      // appBar:
      // AppBar(title: const Text("Single Vehicle Tracking")),
      stickyFrontLayer: true,
      concealBacklayerOnBackButton: false,

      // subHeaderAlwaysActive: false,
      // headerHeight:300,
      revealBackLayerAtStart: true,
      subHeader: GestureDetector(
          onVerticalDragUpdate: _handleDrag,
          onVerticalDragEnd: _handleDragEnd,
          child: _buildSubHeader()),

      frontLayer: GestureDetector(
          onVerticalDragUpdate: _handleDrag,
          onVerticalDragEnd: _handleDragEnd,
          child: _buildFrontLayer()),

      backLayer: vehicles.when(
        data: (vehicleData) {
          if (vehicleData == null) {
            return const Center(child: Text('Vehicle data unavailable'));
          }

          for (var vehicle in vehicleData.data!) {
            return GoogleMap(
              rotateGesturesEnabled: false,
              onMapCreated: (controller) async {
                await mapControllerNotifier.initializeController(controller);
                controller.setMapStyle(Utils.mapStyles);
              },
              markers: markers,
              polylines: polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(vehicle.latitude ?? "0"),
                  double.parse(vehicle.longitude ?? "0"),
                ),
                zoom: 14.0,
              ),
            );
          }
          return Divider(
            color: Colors.amber,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error $stack')),
      ),
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0;
      _isBackLayerVisible = _dragOffset > 50;
      if (_isBackLayerVisible) {
        _backdropKey.currentState?.revealBackLayer();
      } else {
        _backdropKey.currentState?.concealBackLayer();
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // Reset drag offset to avoid cumulative drags
    setState(() {
      _dragOffset = 0;
    });
  }

  String timePassedSince(String dateString) {
    try {
      // Define the custom date format
      DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
      // Parse the input string to DateTime
      DateTime date = format.parse(dateString);

      // Get the current time
      DateTime now = DateTime.now();

      // Calculate the difference
      Duration difference = now.difference(date);

      // Extract hours and minutes from the difference
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;

      // Build the result string
      String result = '';
      if (hours > 0) result += '$hours Hour${hours > 1 ? 's' : ''} ';
      if (minutes > 0) result += '$minutes Minute${minutes > 1 ? 's' : ''}';

      return result.isEmpty ? 'Just Now' : result.trim();
    } catch (e) {
      return 'Invalid date format';
    }
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

  Widget _buildSubHeader() {
    final vehicleData = ref.watch(singleLiveVehicleProvider(widget.vehicleId));

    return vehicleData.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(
              child: Text("No data available for this vehicle."));
        }

        var vehicleInfo =
            vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null
            ? double.tryParse(vehicleInfo.speed!)
            : null;
        double? idleSince = vehicleInfo.idleSince != null
            ? double.tryParse(vehicleInfo.idleSince!)
            : null;
        double? stoppageSince = vehicleInfo.stoppageSince != null
            ? double.tryParse(vehicleInfo.stoppageSince!)
            : null;
        double? externalBatteryVoltage =
            vehicleInfo.externalBatteryVoltage != null
                ? double.tryParse(vehicleInfo.externalBatteryVoltage!)
                : null;
        double? gsmSingnalStrength = vehicleInfo.gsmSingnalStrength != null
            ? double.tryParse(vehicleInfo.gsmSingnalStrength!)
            : null;

        savedLat = vehicleInfo.latitude ?? "NA";
        savedLong = vehicleInfo.longitude ?? "NA";

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _isBackLayerVisible == true
                    ? const Center(
                        child: Text(
                        "Tap to reveal more info",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ))
                    : const Center(
                        child: Text(
                        "Swipe Down for Map",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    speed == 0
                        ? const Icon(
                            Icons.adjust_rounded,
                            color: Colors.yellow,
                          )
                        : const Icon(
                            Icons.adjust_rounded,
                            color: Colors.green,
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vehicleInfo.speed == "0"
                            ? const Text(
                                "IDLE",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              )
                            : const Text(
                                "MOVING",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                        stoppageSince! <= 60 && idleSince! <= 60
                            ? Text(
                                "Distance today is ${vehicleInfo.distanceToday} Km",
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              )
                            : Text(
                                "Vehicle Idle Since: ${convertSecondsToHoursMinutes(vehicleInfo.idleSince ?? "0")}\nVehicle Stoppage since: ${convertSecondsToHoursMinutes(vehicleInfo.stoppageSince!)}",
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                        Text(
                          overflow: TextOverflow.clip,
                          maxLines: 5,
                          "Data Received : ${timePassedSince(vehicleInfo.datetime ?? '0')} ago",
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text("${vehicleInfo.speed ?? '0'} Km/h"),
                            speed! == 0
                                ? const Icon(
                                    Icons.speed_rounded,
                                    color: Colors.yellow,
                                  )
                                : speed >= 60
                                    ? const Icon(
                                        Icons.speed_rounded,
                                        color: Colors.red,
                                      )
                                    : speed <= 60
                                        ? const Icon(
                                            Icons.speed_rounded,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.speed_rounded,
                                            color: Colors.black,
                                          ),
                          ],
                        ),
                        Row(
                          children: [
                            vehicleInfo.ignitionStatus == "0"
                                ? const Text("OFF")
                                : const Text("ON"),
                            vehicleInfo.ignitionStatus == "0"
                                ? const Icon(
                                    Icons.key_off,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.key,
                                    color: Colors.green,
                                  ),
                          ],
                        ),
                        vehicleInfo.externalBatteryVoltage == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    "${vehicleInfo.externalBatteryVoltage} v",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  externalBatteryVoltage! < 9
                                      ? const Icon(
                                          Icons.battery_charging_full_rounded,
                                          size: 18,
                                          color: Colors.redAccent,
                                        )
                                      : const Icon(
                                          Icons.battery_charging_full_rounded,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                ],
                              ),
                        vehicleInfo.acStatus == null
                            ? SizedBox()
                            : Row(
                                children: [
                                  vehicleInfo.acStatus == "0"
                                      ? const Text("AC OFF")
                                      : vehicleInfo.acStatus == null
                                          ? const Text("")
                                          : vehicleInfo.acStatus == "1"
                                              ? const Text("AC ON")
                                              : const Text(""),
                                  vehicleInfo.acStatus == "0"
                                      ? const Icon(
                                          Icons.ac_unit,
                                          color: Colors.red,
                                        )
                                      : vehicleInfo.acStatus == "1"
                                          ? const Icon(
                                              Icons.ac_unit,
                                              color: Colors.green,
                                            )
                                          : vehicleInfo.acStatus == null
                                              ? SizedBox()
                                              : SizedBox()
                                ],
                              ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                      "${vehicleInfo.rto ?? "Not Available"}",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      maxLines: 5,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    // const IconButton(
                    //   icon: Icon(Icons.settings_backup_restore_rounded),
                    //   onPressed: null,
                    // ),
                    gsmSingnalStrength == null
                        ? const SizedBox()
                        : Row(
                            children: [
                              // Text(
                              //   "${vehicle.gsmSingnalStrength} ",
                              //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              // ),
                              Icon(
                                gsmSingnalStrength! > 18
                                    ? Icons.signal_cellular_alt_rounded
                                    : gsmSingnalStrength! > 8
                                        ? Icons
                                            .signal_cellular_alt_2_bar_rounded
                                        : Icons
                                            .signal_cellular_alt_1_bar_rounded,
                                size: 25,
                                color: gsmSingnalStrength! > 18
                                    ? Colors.green
                                    : gsmSingnalStrength! > 8
                                        ? Colors.yellow
                                        : Colors.red,
                              )
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Error: $err"),
    );
  }

  Widget _buildFrontLayer() {
    final vehicleData = ref.watch(singleLiveVehicleProvider(widget.vehicleId));
    final dailyReport = ref.watch(dailyReportProvider);

    String calculateDifference(double value1, double value2) {
      double difference = (value1 - value2).toDouble();
      return difference
          .toStringAsFixed(2); // Formats the difference to 2 decimal places
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.lightBlueAccent,
                            size: 30,
                          ),
                          onPressed: () {
                            if (savedLat != null && savedLong != null) {
                              final locationUrl =
                                  "https://www.google.com/maps/search/?api=1&query=${savedLat},${savedLong}";
                              Share.share(
                                  "Check out this location: $locationUrl for the vehicle with number, ${vehicleInfo.rto}.\nSent through the Cordon Track App!");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Location unavailable")),
                              );
                            }
                          },
                        ),
                        const Text(
                          "Share\nLocation",
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.directions,
                            color: Colors.lightBlueAccent,
                            size: 30,
                          ),
                          onPressed: () {
                            if (savedLat != null && savedLong != null) {
                              final googleMapsUrl =
                                  "google.navigation:q=${savedLat},${savedLong}&mode=d";
                              launchUrl(Uri.parse(googleMapsUrl),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Unable to navigate. Location unavailable")),
                              );
                            }
                          },
                        ),
                        const Text("Navigate"),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
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
                            Text(convertSecondsToHoursMinutes(
                                vehicleInfo.runningTime ?? "0"))
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
                                "${convertSecondsToHoursMinutes(vehicleInfo.stoppageTime ?? "0")}")
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
                            Text("${vehicleInfo.avgSpeed ?? "0"} km/h")
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
                            Text("${(vehicleInfo.maxSpeed ?? "0")} km/h")
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
                                "${(vehicleInfo.odometerEnd ?? "0")} kms",
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

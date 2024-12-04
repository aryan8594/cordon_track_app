import 'dart:async';
import 'dart:developer';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/alerts_provider.dart';
import 'package:cordon_track_app/data/data_providers/dashbaord_provider.dart';
import 'package:cordon_track_app/presentation/pages/alerts_page.dart';
import 'package:cordon_track_app/presentation/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cordon_track_app/data/models/dashboard_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Timer? _updateTimer;
  LatLng? _initialLocation; // Nullable until initialized

  @override
  void initState() {
    super.initState();
    _startUpdateTimer();
    initializeMap();

  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        ref.read(dashboardProvider.notifier).fetchDashboardData();
        ref.read(markerProvider.notifier).updateMarkers(context);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> initializeMap() async {
    if (await requestLocationPermission()) {
      try {
        final position = await getCurrentLocation();
        setState(() {
          _initialLocation = LatLng(position.latitude, position.longitude);
        });
      } catch (e) {
        // Handle error (e.g., location services off)
        log("Error fetching location: $e");
      }
    } else {
      // Handle permission denied
      log("Location permission denied");
    }
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    return status.isGranted;
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider's state
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Overview",
                  style: TextStyle(fontSize: 18),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ),
          ),
          Expanded(
            child: dashboardState.when(
              data: (data) => _buildDashboardContent(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DashboardModel dashboardData) {
    // Prepare dataMap with actual data
    Map<String, double> dataMap = {
      "Running Vehicle Count: ${dashboardData.data?.runningVehicleCount?.toString() ?? 0}":
          dashboardData.data?.runningVehicleCount?.toDouble() ?? 0,
      "Idle Vehicle Count: ${dashboardData.data?.idleVehicleCount?.toString() ?? 0}":
          dashboardData.data?.idleVehicleCount?.toDouble() ?? 0,
      "Low Battery Count: ${dashboardData.data?.lowBatteryCount?.toString() ?? 0}":
          dashboardData.data?.lowBatteryCount?.toDouble() ?? 0,
      "No GSM Count: ${dashboardData.data?.nogsmCount?.toString() ?? 0}":
          dashboardData.data?.nogsmCount?.toDouble() ?? 0,
      "No GPS Coverage Count: ${dashboardData.data?.nogpsCoverageCount?.toString() ?? 0}":
          dashboardData.data?.nogpsCoverageCount?.toDouble() ?? 0,
      "Panic Count: ${dashboardData.data?.panicCount?.toString() ?? 0}":
          dashboardData.data?.panicCount?.toDouble() ?? 0,
      // "Speed above 30kmph: ${dashboardData.data?.speed30?.toString() ?? 0}":
      //     dashboardData.data?.speed30?.toDouble() ?? 0,
      // "Speed above 80kmph: ${dashboardData.data?.speed80?.toString() ?? 0}":
      //     dashboardData.data?.speed80?.toDouble() ?? 0,
      "Disconnected: ${dashboardData.data?.disconnected?.toString() ?? 0}":
          dashboardData.data?.disconnected?.toDouble() ?? 0,
    };
    final markers = ref.watch(markerProvider);
    final mapControllerNotifier = ref.read(mapControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // Navigate to LiveMapPage (index 2)
                  ref.read(navigationIndexProvider.notifier).state = 2;
                },
                child: Card(
                  color: Colors.white70,
                  child: Stack(
                    children: [
                      // The Google Map
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.all(2),
                        width: 175,
                        height: 300,
                        child:  _initialLocation == null
                        ?const Center(child: CircularProgressIndicator()) // Loading state
                        :GoogleMap(
                          key: const PageStorageKey('MapPage'),
                          zoomControlsEnabled: false,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: _initialLocation ?? const LatLng(12.976692, 77.576249),
                            zoom: 10,
                          ),
                          onMapCreated: (controller) async {
                            // ignore: deprecated_member_use
                            controller.setMapStyle(Utils.mapStyles);
                            await mapControllerNotifier
                                .initializeController(controller);
                            log("controller initialized");
                            ref
                                .read(markerProvider.notifier)
                                // ignore: use_build_context_synchronously
                                .updateMarkers(context);
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled : false,
                          compassEnabled: true,
                          rotateGesturesEnabled: false,
                        ),
                      ),
                      // Transparent overlay to block interactions with the map
                      Container(
                        width: 175,
                        height: 300,
                        color: Colors
                            .transparent, // Blocks touches but keeps visibility
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AlertsPage()),
                      ).then((_) {
                        // Reset the notification state
                        ref.read(newAlertsProvider.notifier).resetAlerts();
                      });
                    },
                    child: Card(
                      color: Colors.white70,
                      child: SizedBox(
                        width: 175,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.report_problem_rounded,
                              size: 100,
                              color:
                                  dashboardData.data!.panicCount!.toDouble() > 0
                                      ? Colors.redAccent
                                      : Colors.lightBlueAccent,
                            ),
                            Text(
                              dashboardData.data!.panicCount!.toDouble() > 0
                                  ? "Panic Alerts: ${dashboardData.data?.panicCount?.toString() ?? 0}"
                                  : "No Panic Alerts",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to LiveMapPage (index 2)
                      ref.read(navigationIndexProvider.notifier).state = 1;
                    },
                    child: Card(
                      color: Colors.white70,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: 175,
                        height: 150,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.speed_rounded,
                                color:
                                    dashboardData.data!.speed80!.toDouble() > 0
                                        ? Colors.red
                                        : Colors.lightBlueAccent,
                                size: 100,
                              ),
                              Row(
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.clip,
                                      dashboardData.data!.speed80!.toDouble() >
                                              0
                                          ? "Vehicle Overspeeding:"
                                          : "No Vehicle is Overspeeding"),
                                ],
                              ),
                              Text(
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                  dashboardData.data!.speed80!.toDouble() > 0
                                      ? "${dashboardData.data?.speed80?.toString() ?? 0} (Over 80km/h)"
                                      : "${dashboardData.data?.speed30?.toString() ?? 0} (Over 30km/h)"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              // Navigate to LiveMapPage (index 2)
              ref.read(navigationIndexProvider.notifier).state = 1;
            },
            child: Card(
              color: Colors.white70,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        PieChart(
                          dataMap: dataMap,
                          animationDuration: const Duration(milliseconds: 1000),
                          chartLegendSpacing: 30,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: "All",
                          legendOptions: const LegendOptions(
                            showLegendsInRow: true,
                            legendPosition: LegendPosition.bottom,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            decimalPlaces: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Transparent overlay to block interactions with the map
                  Container(
                    width: 175,
                    height: 300,
                    color: Colors
                        .transparent, // Blocks touches but keeps visibility
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
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





// Map<String, double> dataMap = {
//             "Running Vehicle Count: ${dashboardData.data?.runningVehicleCount?.toString() ?? 0}":
//                 dashboardData.data?.runningVehicleCount?.toDouble() ?? 0 ,
//             "Idle Vehicle Count: ${dashboardData.data?.idleVehicleCount?.toString()?? 0}":
//                 dashboardData.data?.idleVehicleCount?.toDouble() ?? 0,
//             "Low Battery Count: ${dashboardData.data?.lowBatteryCount?.toString() ?? 0}":
//                 dashboardData.data?.lowBatteryCount?.toDouble() ?? 0,
//             "No GSM Count: ${dashboardData.data?.nogsmCount?.toString() ?? 0}":
//                 dashboardData.data?.nogsmCount?.toDouble() ?? 0,
//             "Panic Count: ${dashboardData.data?.panicCount?.toString() ?? 0}":
//                 dashboardData.data?.panicCount?.toDouble() ?? 0,
//             "Speed above 30kmph: ${dashboardData.data?.speed30?.toString() ?? 0}":
//                 dashboardData.data?.speed30?.toDouble() ?? 0,
//             "Speed above 80kmph: ${dashboardData.data?.speed80?.toString() ?? 0}":
//                 dashboardData.data?.speed80?.toDouble() ?? 0,
//             "Disconnected: ${dashboardData.data?.disconnected?.toString() ?? 0}":
//                 dashboardData.data?.disconnected?.toDouble() ?? 0,
//           };


// Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Fleet Summary Section
//       Card(
//         margin: const EdgeInsets.all(16.0),
//         child: ListTile(
//           title: Text("Total Vehicles: ${dashboardData.data?.vehicleCount ?? 'N/A'}"),
//           subtitle: Text(
//             "Running: ${dashboardData.data?.runningVehicleCount ?? 0} | Idle: ${dashboardData.data?.idleVehicleCount ?? 0}",
//           ),
//         ),
//       ),
//       // Vehicles List
//       Expanded(
//         child: ListView.builder(
//           itemCount: dashboardData.vehicles?.length ?? 0,
//           itemBuilder: (context, index) {
//             final vehicle = dashboardData.vehicles![index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: ListTile(
//                 title: Text(vehicle.location ?? 'Unknown Location'),
//                 subtitle: Text("Speed: ${vehicle.speed ?? 'N/A'} km/h"),
//                 trailing: Text(vehicle.rto ?? ''),
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );
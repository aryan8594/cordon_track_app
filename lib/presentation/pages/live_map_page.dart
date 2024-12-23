// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/navigate_to_search_provider.dart';
import 'package:cordon_track_app/business_logic/search_query_provider.dart';
import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class LiveMapPage extends ConsumerStatefulWidget {
  const LiveMapPage({super.key});

  @override
  _LiveMapPageState createState() => _LiveMapPageState();
}

class _LiveMapPageState extends ConsumerState<LiveMapPage> {
  Timer? _updateTimer;
  // Completer<GoogleMapController> _controller = Completer();
  late MapControllerNotifier mapControllerNotifier;
  // ignore: unused_field
  LatLng? _initialLocation;

  @override
  void initState() {
    super.initState();
    initializeMap();
    ref.read(markerProvider.notifier).updateMarkers(context);
    mapControllerNotifier = ref.read(mapControllerProvider.notifier);
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
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
  dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = ref.watch(markerProvider);
    final filteredVehicles = ref.watch(filteredVehiclesProvider);
    final isSearchVisible = ref.watch(isSearchVisibleProvider);
    final mapControllerNotifier = ref.read(mapControllerProvider.notifier);
    final initialCameraPositionAsync = ref.watch(initialCameraPositionProvider);

    // final mapController = ref.read(mapControllerProvider);

    return Scaffold(
      body:
          // markers.isEmpty
          // ?const Center(child: CircularProgressIndicator()) // Loading state
          // :
          initialCameraPositionAsync.when(
        data: (initialCameraPosition) {
          return Stack(
            children: [
              GoogleMap(
                key: const PageStorageKey('MapPage'),
                zoomControlsEnabled: false,
                markers: markers,
                initialCameraPosition: initialCameraPosition,
                // CameraPosition(
                //   target: _initialLocation ?? const LatLng(12.976692, 77.576249),
                //   zoom:12,
                // ),
                onMapCreated: (controller) async {
                  // ignore: deprecated_member_use
                  controller.setMapStyle(Utils.mapStyles);

                  await mapControllerNotifier.initializeController(controller);
                  log("controller initalized");

                  // ref.read(markerProvider.notifier).attachMapController(controller);
                },
                myLocationEnabled: true,
                compassEnabled: true,
                rotateGesturesEnabled: false,
              ),
              Positioned(
                left: 5,
                top: 10,
                child: IconButton(
                  icon: Icon(isSearchVisible ? Icons.close : Icons.search),
                  onPressed: () {
                    ref.read(isSearchVisibleProvider.notifier).state =
                        !isSearchVisible;
                    if (!isSearchVisible) {
                      ref.read(searchQueryProvider.notifier).state = '';
                    }
                  },
                ),
              ),
              if (isSearchVisible)
                Positioned(
                  top: 60,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (query) => ref
                                  .read(searchQueryProvider.notifier)
                                  .state = query,
                              decoration: const InputDecoration(
                                hintText: 'Search by RTO Number...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (filteredVehicles.isNotEmpty)
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                          ),
                          child: ListView.builder(
                            itemCount: filteredVehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = filteredVehicles[index];
                              return ListTile(
                                title: Text(vehicle.rto ?? 'Unknown RTO'),
                                // subtitle: Text('Vehicle ID: ${vehicle.id}'),
                                onTap: () {
                                  navigateToVehicle(ref, vehicle, context);
                                  ref
                                      .read(isSearchVisibleProvider.notifier)
                                      .state = !isSearchVisible;
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error loading map: $error'),
        ),
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

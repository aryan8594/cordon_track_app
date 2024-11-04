import 'dart:developer';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/navigate_to_search_provider.dart';
import 'package:cordon_track_app/business_logic/search_query_provider.dart';
import 'package:cordon_track_app/business_logic/single_marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/live_vehicle_provider.dart';
import 'package:cordon_track_app/business_logic/marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:cordon_track_app/presentation/widgets/vehicle_info_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../../data/models/live_vehicle_model.dart';





class SingleLiveMapPage extends ConsumerStatefulWidget {
  final dynamic specificVehicleID;



  const SingleLiveMapPage({super.key, required this.specificVehicleID});

  @override
  _LiveMapPageState createState() => _LiveMapPageState();
}

class _LiveMapPageState extends ConsumerState<SingleLiveMapPage> {
  Timer? _updateTimer;
  // Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
    _startUpdateTimer();

  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        ref.read(singleMarkerProvider.notifier).updateMarkers(context);
      } else {
        timer.cancel();
      }
    });
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
    final markers = ref.watch(singleMarkerProvider); 

    // final mapController = ref.read(mapControllerProvider);

    return Scaffold(

      body: Stack(
        children: [
          GoogleMap(
            key: const PageStorageKey('MapPage'),
            zoomControlsEnabled : false,
            markers: markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.976692, 77.576249),
              zoom: 10,
            ),
            onMapCreated: (controller) {
                controller.setMapStyle(Utils.mapStyles);

                  ref.read(mapControllerProvider.notifier).initializeController(controller);
                log("controller initalized");
              

              // ref.read(markerProvider.notifier).attachMapController(controller);

              ref.read(singleMarkerProvider.notifier).updateMarkers(context);
            },
            myLocationEnabled: true,
            compassEnabled: true,
            rotateGesturesEnabled: false,
          ),
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

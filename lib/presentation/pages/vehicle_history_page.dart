import 'dart:developer';
import 'dart:math';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/poly_line_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';


class VehicleHistoryPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleHistoryPage({required this.vehicleId});

  @override
  _VehicleHistoryPageState createState() => _VehicleHistoryPageState();
}

class _VehicleHistoryPageState extends ConsumerState<VehicleHistoryPage> {
  late GoogleMapController _mapController;
  DateTime? fromDate;
  DateTime? toDate;
  Set<Polyline> polylines = {};
  Set<Marker> arrowMarkers = {};

  // Function to load polylines with custom dates
  void loadPolylinesWithCustomDates() {
    if (fromDate != null && toDate != null) {
      ref
          .read(polyLineProvider(widget.vehicleId).notifier)
          .loadVehicleHistoryPolyline(widget.vehicleId, fromDate!, toDate!);
    }
  }
  
  List<LatLng> _getArrowPoints(List<LatLng> polylineCoordinates) {
    List<LatLng> arrowPoints = [];
    for (int i = 0; i < polylineCoordinates.length; i += 10) {
      arrowPoints.add(polylineCoordinates[i]);
    }
    return arrowPoints;
  }

  // Method to create markers for arrow points
  Set<Marker> _createArrowMarkers(List<LatLng> arrowPoints) {
    return arrowPoints
        .asMap()
        .entries
        .map(
          (entry) => Marker(
            markerId: MarkerId('arrow_${entry.key}'),
            position: entry.value,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            rotation: _calculateBearing(entry.value, arrowPoints),
            flat: true,
          ),
        )
        .toSet();
  }

  // Function to calculate bearing between two points
  double _calculateBearing(LatLng start, List<LatLng> points) {
    final index = points.indexOf(start);
    if (index == points.length - 1) return 0.0; // No next point, return 0 rotation
    final nextPoint = points[index + 1];
    final lat1 = start.latitude * (3.141592653589793 / 180.0);
    final lon1 = start.longitude * (3.141592653589793 / 180.0);
    final lat2 = nextPoint.latitude * (3.141592653589793 / 180.0);
    final lon2 = nextPoint.longitude * (3.141592653589793 / 180.0);

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(y, x) * 180.0 / 3.141592653589793 + 360.0) % 360.0;
  }

  @override
  Widget build(BuildContext context) {
    // Watch polyline data for the specific vehicle ID
    final polylines = ref.watch(polyLineProvider(widget.vehicleId));
    final List<LatLng> polylineCoordinates = List<LatLng>.from(polylines.isNotEmpty ? polylines.first.points : []);

    // Calculate arrow points
    final arrowPoints = _getArrowPoints(polylineCoordinates);

    final arrowMarkers = _createArrowMarkers(arrowPoints);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Vehicle History"),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              final pickedDates = await showBoardDateTimeMultiPicker(
            context: context,
            pickerType: DateTimePickerType.datetime,
            // minimumDate: DateTime.now().add(const Duration(days: 1)),
            startDate: fromDate,
            endDate: toDate,
            options: const BoardDateTimeOptions(
              languages: BoardPickerLanguages.en(),
              startDayOfWeek: DateTime.sunday,
              pickerFormat: PickerFormat.ymd,
              // topMargin: 0,
            ),
            headerWidget: Container(
              height: 60,
              margin: const EdgeInsets.all((8)),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.blueAccent, width: 4),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                'Select Date-Range',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
              ),
            ),
          );
              

              if (pickedDates != null) {
                fromDate = pickedDates.start as DateTime;
                toDate = pickedDates.end as DateTime;
                loadPolylinesWithCustomDates();
                print("dates selected $pickedDates");
              
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(12.976692, 77.576249),
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
          controller.setMapStyle(Utils.mapStyles);
        },
        polylines: polylines,
        markers: arrowMarkers,
        myLocationEnabled: true,
        compassEnabled: true,
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

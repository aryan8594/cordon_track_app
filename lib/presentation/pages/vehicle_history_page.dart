import 'dart:developer';
// import 'dart:math';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/poly_line_provider.dart';
import 'package:cordon_track_app/data/data_providers/vehicle_history_provider.dart';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:basic_utils/basic_utils.dart';



class VehicleHistoryPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleHistoryPage({required this.vehicleId, Key? key}) : super(key: key);

  @override
  _VehicleHistoryPageState createState() => _VehicleHistoryPageState();
}

class _VehicleHistoryPageState extends ConsumerState<VehicleHistoryPage> {

  DateTime? fromDate;
  DateTime? toDate;
  String selectedRange = 'Today';


  @override
  void initState() {
  super.initState();
  // Automatically load today's data when the page opens
  WidgetsBinding.instance.addPostFrameCallback((_) {
    loadPolylinesWithCustomDates();
  });
}


  // Load Polylines and Markers together
  Future<void> loadPolylinesWithCustomDates() async {
        if (mounted) {

    }

    if (fromDate != null && toDate != null) {
      ref
          .read(polyLineProvider(widget.vehicleId).notifier)
          .loadVehicleHistoryPolylineMarkers(widget.vehicleId, fromDate!, toDate!);
    }

    setState(() {});
  }


  @override
  void dispose() {
    if (!mounted) {
      ref.read(mapControllerProvider.notifier).disposeController();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final polylines = ref.watch(polylineStateProvider(widget.vehicleId));
    final markers = ref.watch(markerStateProvider(widget.vehicleId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => showDateRangeSelectionSheet(context),
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
              Icon(Icons.date_range),
            ],
          ),
        ),
      
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(12.976692, 77.576249),
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                ref.read(mapControllerProvider.notifier).initializeController(controller);
                controller.setMapStyle(Utils.mapStyles);
                // _mapController = controller;
              },
              markers: markers,
              polylines: polylines,
              myLocationEnabled: true,
              compassEnabled: true,
              rotateGesturesEnabled: false,
            ),
          ),
        ],
      ),
    );
  }

  void showDateRangeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle:true,
      isScrollControlled : true, 
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            //TODAY
            ListTile(
              title: const Text('Today'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0);
                toDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Today';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //YESTERDAY
            ListTile(
              title: const Text('Yesterday'),
              onTap: () {
                final yesterday = DateTime.now().subtract(const Duration(days: 1));
                fromDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
                toDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
                selectedRange = 'Yesterday';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //THIS WEEK
            ListTile(
              title: const Text('This Week'),
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
              title: const Text('Last Week'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateUtil.startOfWeek().subtract(const Duration(days: 7));
                toDate = fromDate!.add(Duration(days: 7));
                selectedRange = 'Last Week';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST 7 DAYS
            ListTile(
              title: const Text('Last 7 Days'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0).subtract(const Duration(days: 7));
                toDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Last 7 Days';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST 15 DAYS
            ListTile(
              title: const Text('Last 15 Days'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0).subtract(const Duration(days: 15));
                toDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Last 15 Days';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //THIS MONTH
            ListTile(
              title: const Text('This Month'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateUtil.startOfMonth();
                toDate = fromDate!.add(const Duration(days:30));
                selectedRange = 'This Month';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST MONTH
            ListTile(
              title: const Text('Last Month'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateUtil.startOfMonth().subtract(const Duration(days: 30));
                toDate = fromDate!.add(const Duration(days: 30));
                selectedRange = 'Last Month';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //LAST 30 DAYS
            ListTile(
              title: const Text('Last 30 Days'),
              onTap: () {
                final today = DateTime.now();
                fromDate = DateTime(today.year, today.month, today.day, 0, 0, 0).subtract(const Duration(days: 30));
                toDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
                selectedRange = 'Last 30 Days';
                Navigator.pop(context);
                loadPolylinesWithCustomDates();
              },
            ),
            //CUSTOM DATE PICKER
            ListTile(
              title: const Text('Custom Range'),
              onTap: () async {
                Navigator.pop(context);

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
                textAlign:TextAlign.center,
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
    final firstDayWeek = DateTime(today.year, today.month, today.day, 23, 59, 59);
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

import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:backdrop/backdrop.dart';
import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/business_logic/poly_line_provider.dart';
import 'package:cordon_track_app/business_logic/single_marker_provider.dart';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class SingleVehicleMapPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const SingleVehicleMapPage({Key? key, required this.vehicleId}) : super(key: key);

  @override
  ConsumerState<SingleVehicleMapPage> createState() => _SingleVehicleMapPageState();
}

class _SingleVehicleMapPageState extends ConsumerState<SingleVehicleMapPage> {
  Timer? _updateTimer;
  final _backdropKey = GlobalKey<BackdropScaffoldState>();
  double _dragOffset = 0.0;
  bool _isBackLayerVisible = false;
//  DateTime now = DateTime.now();



  // DateTime fromDate = DateTime.now().subtract(Duration(days: 1));
  // DateTime toDate = DateTime.now();

  Set<Polyline> polylines = {};
  
  DateTime now = DateTime.now();
  late DateTime fromDate;
  late DateTime toDate;

@override
  void initState() {
    super.initState();
   
  fromDate = DateTime(now.year, now.month, now.day, 0, 0, 1); // Start of the day
  toDate = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of the day

    Future.microtask(() {
        loadPolylinesWithCustomDates();
      });
    ref.read(singleMarkerProvider(widget.vehicleId).notifier).updateMarkers(context);
    _startUpdateTimer();
  }

void _startUpdateTimer() {
  _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    if (mounted) {
      // Update from and to dates for the refresh
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime(now.year, now.month, now.day, 0, 0, 1); // Start of the day
      DateTime toDate = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of the day

      // Clear polylines and reload with new data
      Future.microtask(() {
        loadPolylinesWithCustomDates();
      });
      ref.read(singleMarkerProvider(widget.vehicleId).notifier).updateMarkers(context);
    } else {
      timer.cancel();
    }
  });
}



        void loadPolylinesWithCustomDates() {
      if (fromDate != null && toDate != null) {
        ref.read(polyLineProvider(widget.vehicleId).notifier)
            .loadVehicleHistoryPolyline(widget.vehicleId, fromDate!, toDate!); 

            
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
   polylines = ref.watch(polyLineProvider(widget.vehicleId));
    return 
    BackdropScaffold(
      key: _backdropKey,
      // appBar: 
      // AppBar(title: const Text("Single Vehicle Tracking")),
      stickyFrontLayer: true,
      concealBacklayerOnBackButton : false,
      
      // subHeaderAlwaysActive: false,
      // headerHeight:300,
      revealBackLayerAtStart: true,
      subHeader: 
      GestureDetector(
          onVerticalDragUpdate: _handleDrag,
              onVerticalDragEnd: _handleDragEnd,
          child:_buildSubHeader()
          ),
      

      frontLayer:GestureDetector(
        onVerticalDragUpdate: _handleDrag,
              onVerticalDragEnd: _handleDragEnd,
        child: _buildFrontLayer()
        ),
      
      backLayer: vehicles.when(
        data: (vehicleData) {
          if (vehicleData == null) {
            return const Center(child: Text('Vehicle data unavailable'));
          }



          for (var vehicle in vehicleData.data!) {
            return GoogleMap(
              onMapCreated: (controller) {
                ref.read(mapControllerProvider.notifier).initializeController(controller);
                controller.setMapStyle(Utils.mapStyles);
              },
              markers: markers,
              polylines: polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(vehicle.latitude!),
                  double.parse(vehicle.longitude!),
                ),
                zoom: 14.0,
              ),
            );
          }
          return Divider(color: Colors.amber,);
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


Widget _buildSubHeader() {

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
final vehicleData = ref.watch(singleLiveVehicleProvider(widget.vehicleId));

    return vehicleData.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(child: Text("No data available for this vehicle."));
        }

        var vehicleInfo = vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null ? double.tryParse(vehicleInfo.speed!) : null;
        double? idleSince = vehicleInfo.idleSince != null ? double.tryParse(vehicleInfo.idleSince!) : null;
        double? stoppageSince = vehicleInfo.stoppageSince != null ? double.tryParse(vehicleInfo.stoppageSince!) : null;
        double? externalBatteryVoltage = vehicleInfo.externalBatteryVoltage != null ? double.tryParse(vehicleInfo.externalBatteryVoltage!) : null;
        

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
            ?const Center(child: Text("Tap to reveal more info", style: TextStyle(fontSize: 10, color: Colors.grey),))
            :const Center(child: Text("Swipe Down for Map", style: TextStyle(fontSize: 10, color: Colors.grey),)),
            
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                speed == 0
                ? const Icon(Icons.adjust_rounded, color: Colors.yellow,)
                : const Icon(Icons.adjust_rounded, color: Colors.green,),
    
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vehicleInfo.speed == "0"
                    ?const Text("IDLE", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.yellow),)
                    :const Text("MOVING", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),),
    
                     stoppageSince! <= 0 && idleSince! <= 0 
                    ?Text("Distance today is ${vehicleInfo.distanceToday} Km", style: const TextStyle(fontSize: 10,color: Colors.grey),)
                    :Text("Vehicle Idle Since: ${convertSecondsToHoursMinutes(vehicleInfo.idleSince!)}\nVehicle Stoppage since: ${convertSecondsToHoursMinutes(vehicleInfo.stoppageSince!)}", 
                    style: const TextStyle(fontSize: 10,color: Colors.grey),
                    ),
    
    
                    const Text("Data Received : 10 seconds ago", style: TextStyle(fontSize: 10, color: Colors.grey),)
                  ],
                ),
                const SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
    
                      children: [
                        Text("${vehicleInfo.speed} Km/h"),
                        speed! == 0
                        ?const Icon(Icons.speed_rounded, color: Colors.yellow,)
                        :speed >= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.red,)
                        :speed <= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.green,)
                        :const Icon(Icons.speed_rounded, color: Colors.black,),
                      ],
                    ),
                    Row(
    
                      children: [
                        vehicleInfo.ignitionStatus == "0"
                        ?const Text("OFF")
                        :const Text("ON"),
                        vehicleInfo.ignitionStatus == "0"
                        ?const Icon(Icons.key_off, color: Colors.red,)
                        :const Icon(Icons.key, color: Colors.green,),
                      ],
                    ),
                    vehicleInfo.externalBatteryVoltage == null
                      ?const SizedBox()
                      :Row(
                      children: [
                        Text("${vehicleInfo.externalBatteryVoltage} v", style: TextStyle(fontSize: 15),),
                        externalBatteryVoltage! < 8
                        ? const Icon(Icons.battery_charging_full_rounded, size: 18,color: Colors.redAccent,)
                        : const Icon(Icons.battery_charging_full_rounded, size: 18,color: Colors.green,),

                      ],
                    ),
                    vehicleInfo.acStatus == null
                    ?SizedBox()
                    :Row(
                      children: [
                        vehicleInfo.acStatus == "0"
                        ?const Text("AC OFF")
                        :vehicleInfo.acStatus == null
                        ?const Text("")
                        :vehicleInfo.acStatus == "1"
                        ?const Text("AC ON")
                        :const Text(""),
                        vehicleInfo.acStatus == "0"
                        ?const Icon(Icons.ac_unit, color: Colors.red, )
                        :vehicleInfo.acStatus == "1"
                        ?const Icon(Icons.ac_unit, color: Colors.green, )
                        :vehicleInfo.acStatus == null
                        ?SizedBox()
                        :SizedBox()
                      ],
                    ),
                    
    
                  ],
                )
              ],
            ),
           const SizedBox(height: 11,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(
                  "${vehicleInfo.rto}", 
                  overflow: TextOverflow.clip,
                          softWrap: true,
                          maxLines: 5,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                const Icon(Icons.settings_backup_restore_rounded),
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
    String convertSecondsToHoursMinutes(String secondsString) {
  // Convert the string to an integer
  int totalSeconds = int.tryParse(secondsString) ?? 0;

  // Create a Duration object
  Duration duration = Duration(seconds: totalSeconds);

  // Extract hours and minutes
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  // Return formatted string
  return '${hours}h ${minutes}m';
}
    
    final vehicleData = ref.watch(singleLiveVehicleProvider(widget.vehicleId));
    return vehicleData.when(
      data: (vehicle) {
        if (vehicle == null || vehicle.data == null || vehicle.data!.isEmpty) {
          return const Center(child: Text("No data available for this vehicle."));
        }

        var vehicleInfo = vehicle.data![0]; // Access the first item in the data list
        double? speed = vehicleInfo.speed != null ? double.tryParse(vehicleInfo.speed!) : null;
    return Card(  
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vehicleInfo.speed == "0"
                ? const Icon(Icons.adjust_rounded, color: Colors.yellow,)
                : const Icon(Icons.adjust_rounded, color: Colors.green,),
    
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vehicleInfo.speed == "0"
                    ?const Text("IDLE", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.yellow),)
                    :const Text("MOVING", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),),
    
                    vehicleInfo.idleSince == "0" || vehicleInfo.stoppageSince == "0"
                    ?Text("Distance today is ${vehicleInfo.distanceToday} Km", style: const TextStyle(fontSize: 10,color: Colors.grey),)
                    :Text("Vehicle Idle Since: ${vehicleInfo.idleSince}\nVehicle Stoppage since: ${vehicleInfo.stoppageSince}", style: const TextStyle(fontSize: 10,color: Colors.grey),),
    
    
                    const Text("Data Received : 10 seconds ago", style: TextStyle(fontSize: 10, color: Colors.grey),)
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
    
                      children: [
                        Text("${vehicleInfo.speed} Kmph"),
                        speed! == 0
                        ?const Icon(Icons.speed_rounded, color: Colors.yellow,)
                        :speed >= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.red,)
                        :speed <= 60
                        ?const Icon(Icons.speed_rounded, color: Colors.green,)
                        :const Icon(Icons.speed_rounded, color: Colors.black,),
                      ],
                    ),
                    Row(
    
                      children: [
                        vehicleInfo.ignitionStatus == "0"
                        ?const Text("OFF")
                        :const Text("ON"),
                        vehicleInfo.ignitionStatus == "0"
                        ?const Icon(Icons.key_off, color: Colors.red,)
                        :const Icon(Icons.key, color: Colors.green,),
                      ],
                    ),
                    Row(
                      children: [
                        vehicleInfo.acStatus == "0"
                        ?const Text("AC OFF")
                        :vehicleInfo.acStatus == null
                        ?const Text("")
                        :vehicleInfo.acStatus == "1"
                        ?const Text("AC ON")
                        :const Text(""),
                        vehicleInfo.acStatus == "0"
                        ?const Icon(Icons.ac_unit, color: Colors.red, )
                        :vehicleInfo.acStatus == "1"
                        ?const Icon(Icons.ac_unit, color: Colors.green, )
                        :vehicleInfo.acStatus == null
                        ?const Text("")
                        :const Text(""),
                      ],
                    )
    
                  ],
                )
              ],
            ),
           const SizedBox(height: 11,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(
                  "${vehicleInfo.rto}", 
                  overflow: TextOverflow.clip,
                          softWrap: true,
                          maxLines: 5,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                const Icon(Icons.settings_backup_restore_rounded),
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

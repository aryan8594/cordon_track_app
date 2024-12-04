import 'dart:async';
import 'dart:developer';
import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/data/data_providers/single_live_vehicle_provider.dart';
import 'package:cordon_track_app/data/repositories/live_vehicle_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';

import '../presentation/widgets/vehicle_info_sheet.dart';

final markerProvider =
    StateNotifierProvider<MarkerNotifier, Set<Marker>>((ref) {
  return MarkerNotifier(ref);
});
// final selectedVehicleIdProvider = StateProvider<String?>((ref) => null);

// final mapControllerProvider = Provider<Completer<GoogleMapController>>((ref) {
//   return Completer<GoogleMapController>();
// });

class MarkerNotifier extends StateNotifier<Set<Marker>> {
  final Ref ref;
  MarkerNotifier(this.ref) : super({}) {}
  Map<String, BitmapDescriptor> _iconCache =
      {}; // Icon cache for better performance
  bool isDisposed = false;
  // Completer<GoogleMapController> _controller = Completer();

  //   void dispose() {
//   ref.read(selectedVehicleIdProvider.notifier).state = null;
//   isDisposed = true;
//   super.dispose();
// }

  // Fetch vehicle data and update markers
  Future<void> updateMarkers(BuildContext context) async {
    try {
      List<Data>? vehicles =
          await LiveVehicleRepository(ref).fetchLiveVehicleData();

      if (vehicles != null) {
        Set<Marker> updatedMarkers =
            await _generateMarkers(context, vehicles, ref);
        state = updatedMarkers; // Update the state with new markers
      }
    } catch (e) {
      print("Error fetching vehicle data: $e");
    }
  }

  // Method to generate markers from the vehicle data
  Future<Set<Marker>> _generateMarkers(
      BuildContext context, List<Data> vehicles, Ref ref) async {
    // Marker savedMarker;
    Map<String, Marker> updatedMarkers = {
      for (var marker in state) marker.markerId.value: marker
    }; // Existing markers

    for (var vehicle in vehicles) {
      if (vehicle.latitude != null && vehicle.longitude != null) {
        LatLng newPosition = LatLng(double.parse(vehicle.latitude.toString()),
            double.parse(vehicle.longitude.toString()));
        double rotation = vehicle.direction != null
            ? double.tryParse(vehicle.direction!) ?? 0.0
            : 0.0;

        BitmapDescriptor newIcon = await setCustomMapPin(vehicle);

        // If the marker already exists, animate the position
        if (updatedMarkers.containsKey(vehicle.id!)) {
          Marker oldMarker = updatedMarkers[vehicle.id!]!;
          _animateMarkerPosition(
              oldMarker, newPosition, vehicle, newIcon, updatedMarkers, ref);
        } else {
          // Create a new marker if it doesn't exist
          Marker newMarker = Marker(
            anchor: const Offset(0.5, 0.5),
            markerId: MarkerId(vehicle.id!),
            position: newPosition,
            icon: newIcon,
            infoWindow: InfoWindow(
              anchor: const Offset(0.5, 0.5),
              title: vehicle.rto ?? 'Unknown RTO',
              snippet: 'Speed: ${vehicle.speed ?? 'N/A'} km/h',
            ),
            rotation: rotation,
            onTap: () async {
              //  ref.read(selectedVehicleIdProvider.notifier).state = vehicle.id;
              // Set selected vehicle
              // onMarkerTap(context, vehicle.id.toString());
              // log("${ref.read(selectedVehicleIdProvider)} selected");

              // final controller = ref.read(mapControllerProvider);

              // if (controller != null 
              // // && ref.read(selectedVehicleIdProvider.notifier).state == vehicle.id
              //         ) {
              //           log("animating zoom camera function");
              //   await controller.animateCamera(CameraUpdate.newLatLngZoom(
              //       updatedMarkers[vehicle.id]!.position, 15));
              // }
            },
          );
          updatedMarkers[vehicle.id!] = newMarker;
        }
        // Update the camera position for the selected vehicle
        Future.microtask(() {
          if (ref.read(selectedVehicleIdProvider.notifier).state ==
                  vehicle.id &&
              mounted) {
            // If the selected vehicle, update the camera position

            // if (context.mounted) {
            //   log("camera moving GM ${ref.read(selectedVehicleIdProvider)}");
            //   final GoogleMapController controller = await ref.read(mapControllerProvider).future;
            //   controller.animateCamera(CameraUpdate.newLatLng(newPosition));
            // }

            if (mounted) {
  Future.delayed(const Duration(milliseconds: 2000), () async {
    try {
      final controller = ref.read(mapControllerProvider);
      if (controller != null) {
        log("animating camera to vehicle from delayed");
        await controller
            .animateCamera(CameraUpdate.newLatLng(newPosition));
      }
    } catch (e) {
      log('Error animating camera: $e');
    }
  });
}
          }
        });
      }
    }

    return updatedMarkers.values.toSet();
  }

  // Method to get or generate custom icons based on vehicle data
  Future<BitmapDescriptor> setCustomMapPin(Data vehicle) async {
    String assetPath;
    double? speed =
        vehicle.speed != null ? double.tryParse(vehicle.speed!) : null;
    String gpsStatus = vehicle.gpsStatus?.toString() ?? '0';
    String ignitionStatus = vehicle.ignitionStatus?.toString() ?? '0';
    double? idleSince =
        vehicle.idleSince != null ? double.tryParse(vehicle.idleSince!) : null;
    double? stoppageSince = vehicle.stoppageSince != null
        ? double.tryParse(vehicle.stoppageSince!)
        : null;

    String key = '${vehicle.vType}-${vehicle.gpsStatus}-${vehicle.speed}';
    if (_iconCache.containsKey(key)) {
      return _iconCache[key]!;
    }

    // Determine the asset path for the custom icon
    if (stoppageSince != null && stoppageSince > 10800) {
      assetPath = vehicle.vType == 'car'
          ? 'lib/presentation/assets/cab_black.png'
          : 'lib/presentation/assets/truck_black.png';
    } else if (stoppageSince != null && stoppageSince < 10800) {
      if (vehicle.vType == 'car' ||
          vehicle.vType == null ||
          vehicle.vType == 'Unknown' ||
          vehicle.vType == '') {
        if (speed == null || speed == 0) {
          assetPath = 'lib/presentation/assets/cab_yellow.png';
        } else if (speed > 60) {
          assetPath = 'lib/presentation/assets/cab_red.png';
        } else {
          assetPath = 'lib/presentation/assets/cab_green.png';
        }
      } else {
        if (speed == null || speed == 0) {
          assetPath = 'lib/presentation/assets/truck_yellow.png';
        } else if (speed > 60) {
          assetPath = 'lib/presentation/assets/truck_red.png';
        } else {
          assetPath = 'lib/presentation/assets/truck_green.png';
        }
      }
    } else {
      assetPath =
          'lib/presentation/assets/cab_yellow.png'; // Default if vehicle status is unexpected
    }

    // Create and cache the new icon
    BitmapDescriptor newIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 0.1, size: Size(15, 26.7)),
      assetPath,
    );
    _iconCache[key] = newIcon; // Cache the icon for future use
    return newIcon;
  }

  // Helper to animate marker position smoothly
  void _animateMarkerPosition(
      Marker oldMarker,
      LatLng newPosition,
      Data vehicle,
      BitmapDescriptor newIcon,
      Map<String, Marker> markersMap,
      Ref ref) {
    // if (isDisposed) return;
    const int steps = 10;
    const int animationDuration = 5000;

    double startLat = oldMarker.position.latitude;
    double startLng = oldMarker.position.longitude;
    double endLat = newPosition.latitude;
    double endLng = newPosition.longitude;

    Timer.periodic(const Duration(milliseconds: animationDuration ~/ steps),
        (timer) async {
      double t = timer.tick / steps;
      double currentLat = _lerp(startLat, endLat, t);
      double currentLng = _lerp(startLng, endLng, t);
      LatLng interpolatedPosition = LatLng(currentLat, currentLng);

      // Parse and apply the vehicle's direction for rotation
      double rotation = vehicle.direction != null
          ? double.tryParse(vehicle.direction!) ?? 0.0
          : 0.0;

      // Update the position, rotation, and icon of the marker
      markersMap[oldMarker.markerId.value] = oldMarker.copyWith(
        positionParam: interpolatedPosition,
        rotationParam: rotation,
        iconParam: newIcon,
        infoWindowParam: InfoWindow(
          anchor: const Offset(0.5, 0.5),
          title: vehicle.rto ?? 'Unknown RTO',
          snippet: 'Speed: ${vehicle.speed ?? 'N/A'} km/h',
          onTap: () async {
            // final GoogleMapController controller = await ref.read(mapControllerProvider).future;
            // controller.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
          },
        ),
      );

      // Update the state after each step
      if (mounted) {
        state = markersMap.values.toSet();
      }

      // End the animation after the final step
      if (timer.tick >= steps) {
        timer.cancel();

        //  if (ref.read(selectedVehicleIdProvider.notifier).state == vehicle.id) {
        //       // If the selected vehicle, update the camera position
        //           log("camera moving AM ${ref.read(selectedVehicleIdProvider)}");
        //           final GoogleMapController controller = await ref.read(mapControllerProvider).future;
        //           controller.animateCamera(CameraUpdate.newLatLng(newPosition));
        // }
      }
    });
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  // Helper to move the camera to the vehicle's position
  //   Future<void> _updateCameraPosition(LatLng newPosition) async {
  //     if (ref.read(selectedVehicleIdProvider.notifier).state != null ) {
  //   final GoogleMapController controller = await ref.read(mapControllerProvider).future;
  //   controller.animateCamera(CameraUpdate.newLatLng(newPosition));
  // }
  //   }

  // Attach the GoogleMap controller
  // void attachMapController(GoogleMapController controller) {
  //   final mapControllerCompleter = ref.watch(mapControllerProvider);

  //   if (mapControllerCompleter.isCompleted) {
  //     mapControllerCompleter.complete(controller);
  //   }
  // }

  void onMarkerTap(BuildContext context, String vehicleId) {
    if (context.mounted) {
      Future.microtask(() {
        // ref.raed(selectedVehicleIdProvider.notifier).state = vehicleId;
      });

      showVehicleTopModalSheet(context, vehicleId, ref);
      showVehicleInfoModal(context, vehicleId, ref);
    }
  }
}

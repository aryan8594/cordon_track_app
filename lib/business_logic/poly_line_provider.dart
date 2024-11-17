

// StateNotifier for managing polyline state for a specific vehicle
import 'dart:developer';

import 'package:cordon_track_app/data/data_providers/vehicle_history_provider.dart';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:cordon_track_app/data/repositories/vehicle_history_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Provider for the HistoryVehicleRepository
// final historyVehicleRepositoryProvider = Provider<HistoryVehicleRepository>((ref) {
//   return HistoryVehicleRepository();
// });

/// StateNotifier for managing polyline states
// PolyLineNotifier to manage both arrow markers and polylines

String convertSecondsToHoursMinutes(int secondsInt) {


    // Create a Duration object
    Duration duration = Duration(seconds: secondsInt);

    // Extract hours and minutes
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    // Return formatted string
    return '${hours}h ${minutes}m';
  }

class PolyLineNotifier extends StateNotifier<Map<String, dynamic>> {
  final Ref ref;

  PolyLineNotifier(this.ref)
      : super({'polylines': <Polyline>{}, 'markers': <Marker>{}, 'isPlaying': false, 'currentIndex': 0, 'playbackSpeed': 1.0});

  // State Variables for Playback
  bool get isPlaying => state['isPlaying'];
  int get currentIndex => state['currentIndex'];
  double get playbackSpeed => state['playbackSpeed'];
  
  List<LatLng> polylineCoordinates = []; // Store the coordinates for playback
  
  // Method to toggle play/pause
  void togglePlayPause() {
    state = {...state, 'isPlaying': !isPlaying};
  }
  
  // Method to update playback speed
  void setPlaybackSpeed(double speed) {
    state = {...state, 'playbackSpeed': speed};
  }
  
  // Method to update current index during playback
  void setCurrentIndex(int index) {
    state = {...state, 'currentIndex': index};
  }

  Future<void> loadVehicleHistoryPolylineMarkers(
      String vehicleId, DateTime fromDate, DateTime toDate) async {
    if (!mounted) {
      state = {'polylines': <Polyline>{}, 'markers': <Marker>{}};
    }

    // Clear current polyline and marker data
    state = {'polylines': <Polyline>{}, 'markers': <Marker>{}};
    log("PolyLineNotifier: Clearing polyline and markers state.");

    // Fetch new history data from the repository
    final vehicleHistory = await ref
        .read(historyVehicleRepositoryProvider)
        .fetchVehicleHistory(vehicleId, fromDate, toDate);

    if (vehicleHistory != null && vehicleHistory.data?.history != null) {
      final historyData = vehicleHistory.data!.history!;

      // Create polylines
      final polylineCoordinates = historyData.map((history) {
        return LatLng(
          double.parse(history.lat!),
          double.parse(history.lng!),
        );
      }).toList();

      final Set<Polyline> newPolylines = {
        Polyline(
          polylineId: PolylineId('vehicleHistory_$vehicleId'),
          points: polylineCoordinates,
          color: const Color(0xFF2196F3),
          width: 5,
        ),
      };

      // Create markers with custom icons
      final BitmapDescriptor customArrowIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(7, 4)),
        'lib/presentation/assets/arrow_black.png',
      );

      final BitmapDescriptor customStopIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(16, 16)),
        'lib/presentation/assets/stop_marker.png',
      );

      final Set<Marker> newMarkers = historyData.map((history) {
        double lat = double.tryParse(history.lat ?? '0') ?? 0;
        double lng = double.tryParse(history.lng ?? '0') ?? 0;
        double rotation = double.tryParse(history.direction ?? '0') ?? 0;

        return Marker(
          anchor : const Offset(0.5,0.5),
          markerId: MarkerId(history.id ?? DateTime.now().toString()),
          position: LatLng(lat, lng),
          icon: 
          history.duration! > 60
          ?customStopIcon
          :customArrowIcon,
          rotation: rotation,
          flat: true,
          infoWindow: InfoWindow(
            anchor : const Offset(0.5, 0.5),
            title: 
            history.duration! > 60
            ?'Stoppage Duration: ${convertSecondsToHoursMinutes(history.duration!) ?? 'Unknown'}'
            :'Speed: ${history.speed ?? 'N/A'} km/h',
            // snippet: 'Pakrking: ${history.ptype ?? 'Unknown'}',
          ),
        );
      }).toSet();

      // Update state with both polylines and markers
      state = {
        'polylines': newPolylines,
        'markers': newMarkers,
      };
      log("PolyLineNotifier: New polyline and markers data loaded.");
    } else {
      log("PolyLineNotifier: No data available for the given date range.");
    }
  }
}

/// Providers for Polyline and Marker
final polyLineProvider = StateNotifierProvider.family<PolyLineNotifier, Map<String, dynamic>, String>(
  (ref, vehicleId) => PolyLineNotifier(ref),
);

/// Selector Providers for Polyline and Marker
final polylineStateProvider = Provider.family<Set<Polyline>, String>((ref, vehicleId) {
  final polylineNotifier = ref.watch(polyLineProvider(vehicleId));
  return polylineNotifier['polylines'] as Set<Polyline>? ?? {};
});

final markerStateProvider = Provider.family<Set<Marker>, String>((ref, vehicleId) {
  final markerNotifier = ref.watch(polyLineProvider(vehicleId));
  return markerNotifier['markers'] as Set<Marker>? ?? {};
});

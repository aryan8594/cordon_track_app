// StateNotifier for managing polyline state for a specific vehicle
import 'dart:developer';

import 'package:cordon_track_app/data/data_providers/vehicle_history_provider.dart';
import 'package:cordon_track_app/data/models/polyline_state_model.dart';
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

class PolyLineNotifier extends StateNotifier<PolylineStateModel> {
  final Ref ref;

  List<LatLng> polylineCoordinates = []; // Store the coordinates for playback
   bool get isPlaying => state.isPlaying;
  PolyLineNotifier(this.ref) : super(PolylineStateModel());

  // Method to toggle play/pause
  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
    log("Playback is now ${state.isPlaying ? 'playing' : 'paused'}");
  }

  // // Method to update playback speed
  // void setPlaybackSpeed(double speed) {
  //   state = state.copyWith(playbackSpeed: speed);
  // }

  // Method to update current index during playback
  void setCurrentIndex(int index) async {
  if (index >= 0 && index < state.polylineCoordinates.length) {
    final newPosition = state.polylineCoordinates[index];
    final direction = state.markers
            .firstWhere(
              (marker) => marker.position == newPosition,
              orElse: () => Marker(markerId: const MarkerId('default')),
            )
            .rotation ??
        0.0;

    log("setCurrentIndex called with index: $index, newPosition: $newPosition, direction: $direction");

    // Update the playback marker
    updatePlaybackMarker(newPosition, direction);

    // Update state
    state = state.copyWith(currentIndex: index);

    log("State updated with currentIndex: $index");
  } else {
    log("Index out of bounds in setCurrentIndex: $index");
  }
}






  // Method to update the playback marker position
  void updatePlaybackMarker(LatLng position, double direction) async {

    final BitmapDescriptor customPlaybackIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(35, 63)),
        'lib/presentation/assets/cab_blue.png',
      );

    final Marker newPlaybackMarker = Marker(
      anchor: const Offset(0.5, 0.5),
      markerId: const MarkerId('playbackMarker'),
      rotation: direction,
      position: position,
      icon: customPlaybackIcon,
      flat: true,
    );

    // Update the state to trigger a rebuild
    state = state.copyWith(playbackMarker: newPlaybackMarker);
  }

  // Load Vehicle History and Polylines
  Future<void> loadVehicleHistoryPolylineMarkers(
      String vehicleId, DateTime fromDate, DateTime toDate) async {
    if (!mounted) return;

    // Clear current polyline and marker data
    state = PolylineStateModel();
    log("PolyLineNotifier: Clearing polyline and markers state.");

    // Fetch new history data from the repository
    final vehicleHistory = await ref
        .read(historyVehicleRepositoryProvider)
        .fetchVehicleHistory(vehicleId, fromDate, toDate);

    if (vehicleHistory != null && vehicleHistory.data?.history != null) {
      final historyData = vehicleHistory.data!.history!;

      // Step 1: Create polyline coordinates
      final List<LatLng> polylineCoordinates = historyData.map((history) {
        return LatLng(
          double.parse(history.lat!),
          double.parse(history.lng!),
        );
      }).toList();

      log("Loaded ${polylineCoordinates.length} polyline coordinates.");

      // Step 2: Create the polyline
      final Set<Polyline> newPolylines = {
        Polyline(
          polylineId: PolylineId('vehicleHistory_$vehicleId'),
          points: polylineCoordinates,
          color: const Color(0xFF2196F3),
          width: 5,
        ),
      };

      // Step 3: Create markers with custom icons
      final BitmapDescriptor customArrowIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(7, 4)),
        'lib/presentation/assets/arrow_black.png',
      );

      final BitmapDescriptor customStopIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(16, 16)),
        'lib/presentation/assets/stop_marker.png',
      );

      final BitmapDescriptor customPlaybackIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(35, 63)),
        'lib/presentation/assets/cab_blue.png',
      );

      final Set<Marker> newMarkers = historyData.map((history) {
        double lat = double.tryParse(history.lat ?? '0') ?? 0;
        double lng = double.tryParse(history.lng ?? '0') ?? 0;
        double rotation = double.tryParse(history.direction ?? '0') ?? 0;

        return Marker(
          consumeTapEvents: history.duration! > 60 ? false : true,
          anchor: const Offset(0.5, 0.5),
          markerId: MarkerId(history.id ?? DateTime.now().toString()),
          position: LatLng(lat, lng),
          icon: history.duration! > 60 ? customStopIcon : customArrowIcon,
          rotation: rotation,
          flat: true,
          infoWindow: InfoWindow(
            anchor: const Offset(0.5, 0.5),
            title: history.duration! > 60
                ? 'Stoppage Duration: ${convertSecondsToHoursMinutes(history.duration!) ?? 'Unknown'}'
                : 'Speed: ${history.speed ?? 'N/A'} km/h',
            snippet: ('${history.datetime}'),
          ),
        );
      }).toSet();

      // Step 4: Set an initial playback marker at the starting point
      Marker? initialPlaybackMarker;
      if (polylineCoordinates.isNotEmpty) {
        log("Initial playback marker set at: ${polylineCoordinates.first}");

        initialPlaybackMarker = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: const MarkerId('playbackMarker'),
          position: polylineCoordinates.first,
          icon: customPlaybackIcon,
          flat: true,
        );
      } else {
        log("No coordinates found during initial load.");
      }

      // Step 5: Save the polyline, markers, and coordinates in the state
      state = state.copyWith(
        polylines: newPolylines,
        markers: newMarkers,
        polylineCoordinates: polylineCoordinates, // Save coordinates here
        playbackMarker:
            initialPlaybackMarker, // Set the initial playback marker
        currentIndex: 0, // Reset index to start playback from the beginning
      );

      log("PolyLineNotifier: New polyline and markers data loaded with ${newMarkers.length} markers.");
    } else {
      log("PolyLineNotifier: No data available for the given date range.");
    }
  }
}

/// Providers for Polyline and Marker
final polyLineProvider =
    StateNotifierProvider.family<PolyLineNotifier, PolylineStateModel, String>(
  (ref, vehicleId) => PolyLineNotifier(ref),
);

/// Selector Providers for Polyline and Marker
final polylineStateProvider =
    Provider.family<Set<Polyline>, String>((ref, vehicleId) {
  final polylineState = ref.watch(polyLineProvider(vehicleId));
  return polylineState.polylines;
});

final markerStateProvider =
    Provider.family<Set<Marker>, String>((ref, vehicleId) {
  final polylineState = ref.watch(polyLineProvider(vehicleId));
  return polylineState.markers;
});

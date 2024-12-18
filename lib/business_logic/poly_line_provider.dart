// StateNotifier for managing polyline state for a specific vehicle

import 'dart:developer';

import 'package:cordon_track_app/business_logic/map_controller_provider.dart';
import 'package:cordon_track_app/data/data_providers/vehicle_history_provider.dart';
import 'package:cordon_track_app/data/models/polyline_state_model.dart';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Provider for the HistoryVehicleRepository
// final historyVehicleRepositoryProvider = Provider<HistoryVehicleRepository>((ref) {
//   return HistoryVehicleRepository();
// });

/// StateNotifier for managing polyline states
// PolyLineNotifier to manage both arrow markers and polylines

final historyVehicleProvider =
    StateProvider<VehicleHistoryModel?>((ref) => null);

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
  List<History>? vehicleHistory; // Store history data here
  List<LatLng> polylineCoordinates = []; // Store the coordinates for playback
  bool get isPlaying => state.isPlaying;
  PolyLineNotifier(this.ref) : super(const PolylineStateModel());

  // Method to toggle play/pause
  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
    log("Playback is now ${state.isPlaying ? 'playing' : 'paused'}");
  }

  void pausePlayback() {
    state = state.copyWith(isPlaying: false);
    log("Playback is paused explicitly.");
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
                orElse: () => const Marker(markerId: MarkerId('default')),
              )
              .rotation;

      updatePlaybackMarker(newPosition, direction, index);

      state = state.copyWith(currentIndex: index);
    } else {
      log("Index out of bounds: $index");
    }
  }

  // Method to update the playback marker position
  void updatePlaybackMarker(
      LatLng position, double direction, int index) async {
    if (vehicleHistory == null ||
        index < 0 ||
        index >= vehicleHistory!.length) {
      log("Invalid index or vehicleHistory not loaded.");
      return;
    }

    final historyData = vehicleHistory![index];
    final dateTime = historyData.datetime ?? 'Unknown DateTime';
    final speed = historyData.speed ?? 'Unknown Speed';
    // final ignition = historyData.ignitionStatus ?? "Unnkown";
    final stoppage = historyData.duration ?? 0;

    // String ignitionStatus = "ON";
    // ignition == "1" ? ignitionStatus = "ON" : ignitionStatus = "OFF";

    final BitmapDescriptor customPlaybackIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 45)),
      'lib/presentation/assets/cab_blue.png',
    );

    final Marker newPlaybackMarker = Marker(
      anchor: const Offset(0.5, 0.5),
      markerId: const MarkerId('playbackMarker'),
      rotation: direction,
      position: position,
      icon: customPlaybackIcon,
      flat: true,
      infoWindow: InfoWindow(
        anchor: const Offset(0.5, 0.5),
        title: dateTime,
        snippet: stoppage > 60
            ? 'Stoppage Duration: ${convertSecondsToHoursMinutes(stoppage)}'
            : 'Speed: $speed km/h',
      ),
    );

    state = state.copyWith(playbackMarker: newPlaybackMarker);
    final controller = ref.read(mapControllerProvider.notifier);
    // Center the marker if it goes out of bounds
    if (mounted) {
      await controller.centerMarkerIfOutOfBounds(position);
    }
    // Force playbackMarker to be above the polyline and other markers
    controller.showMarkerInfoWindow(const MarkerId('playbackMarker'));
  }

  // Load Vehicle History and Polylines
  Future<void> loadVehicleHistoryPolylineMarkers(
      String vehicleId, DateTime fromDate, DateTime toDate) async {
    if (!mounted) return;

    // Clear current polyline and marker data
    state = const PolylineStateModel();
    log("PolyLineNotifier: Clearing polyline and markers state.");

    // Fetch new history data from the repository
    final response = await ref
        .read(historyVehicleRepositoryProvider)
        .fetchVehicleHistory(vehicleId, fromDate, toDate);
    ref.read(historyVehicleProvider.notifier).state = response;

    if (response != null && response.data?.history != null) {
      vehicleHistory = response.data!.history; // Set the local variable
      log("Vehicle history loaded with ${vehicleHistory!.length} entries.");

      // Step 1: Create polyline coordinates
      final List<LatLng> polylineCoordinates = vehicleHistory!.map((history) {
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
        const ImageConfiguration(size: Size(25, 45)),
        'lib/presentation/assets/cab_blue.png',
      );

      final Set<Marker> newMarkers = vehicleHistory!.map((history) {
        double lat = double.tryParse(history.lat ?? '0') ?? 0;
        double lng = double.tryParse(history.lng ?? '0') ?? 0;
        double rotation = double.tryParse(history.direction ?? '0') ?? 0;

        return Marker(
          onTap: () {
            if (ref.read(polyLineProvider(vehicleId).notifier).isPlaying) {
              ref.read(polyLineProvider(vehicleId).notifier).pausePlayback();
              log("Playback paused by tapping marker.");
            }
          },
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
                ? 'Stoppage Duration: ${convertSecondsToHoursMinutes(history.duration ?? 0)}'
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
          infoWindow: const InfoWindow(
              anchor: Offset(0.5, 0.5), title: 'DateTime', snippet: 'Speed'),
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
final polyLineProvider = StateNotifierProvider.family
    .autoDispose<PolyLineNotifier, PolylineStateModel, String>(
  (ref, vehicleId) => PolyLineNotifier(ref),
);

/// Selector Providers for Polyline and Marker
final polylineStateProvider =
    Provider.family.autoDispose<Set<Polyline>, String>((ref, vehicleId) {
  final polylineState = ref.watch(polyLineProvider(vehicleId));
  return polylineState.polylines;
});

final markerStateProvider =
    Provider.family.autoDispose<Set<Marker>, String>((ref, vehicleId) {
  ref.keepAlive(); // Prevent disposal until explicitly cleared
  final polylineState = ref.watch(polyLineProvider(vehicleId));
  return polylineState.markers;
});

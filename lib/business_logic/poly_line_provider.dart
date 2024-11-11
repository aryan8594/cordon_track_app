

// StateNotifier for managing polyline state for a specific vehicle
import 'dart:developer';

import 'package:cordon_track_app/data/data_providers/vehicle_history_provider.dart';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:cordon_track_app/data/repositories/vehicle_history_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Provider for the HistoryVehicleRepository
final historyVehicleRepositoryProvider = Provider<HistoryVehicleRepository>((ref) {
  return HistoryVehicleRepository();
});

/// StateNotifier for managing polyline states
class PolyLineNotifier extends StateNotifier<Set<Polyline>> {
  final Ref ref;

  PolyLineNotifier(this.ref) : super({});

  Future<void> loadVehicleHistoryPolyline(
      String vehicleId, DateTime fromDate, DateTime toDate) async {
        if (!mounted) {
          state = {};
        }

    // Clear current polyline data
    state = {}; // Clear existing polyline state
    log("PolyLineNotifier: Clearing polyline state.");

    // Fetch new history data from the repository
    final vehicleHistory = await ref
        .read(historyVehicleRepositoryProvider)
        .fetchVehicleHistory(vehicleId, fromDate, toDate);

    if (vehicleHistory != null && vehicleHistory.data?.history != null) {
      // Process and add new polylines to the state
      final polylineCoordinates = vehicleHistory.data!.history!.map((history) {
        return LatLng(
          double.parse(history.lat!),
          double.parse(history.lng!),
        );
      }).toList();

      state = {
        Polyline(
          polylineId: PolylineId('vehicleHistory_$vehicleId'),
          points: polylineCoordinates,
          color: const Color(0xFF2196F3),
          width: 5,
        ),
      };
      log("PolyLineNotifier: New polyline data loaded with ${polylineCoordinates.length} points.");
    } else {
      log("PolyLineNotifier: No polyline data available for given date range.");
    }
  }
}


/// Provider for the PolyLineNotifier with custom dates
final polyLineProvider = StateNotifierProvider.family<PolyLineNotifier, Set<Polyline>, String>((ref, vehicleId) {
  return PolyLineNotifier(ref);
});
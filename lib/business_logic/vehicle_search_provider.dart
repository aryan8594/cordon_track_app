// providers/vehicle_providers.dart

// Notifier for managing and filtering vehicle data based on search query
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_providers/live_vehicle_provider.dart';

class VehicleSearchNotifier extends StateNotifier<List<Data>> {
  final Ref ref;
  List<Data> _allVehicles = [];

  VehicleSearchNotifier(this.ref) : super([]) {
    _init();

    // Listen for changes in liveVehicleProvider and update the state
    ref.listen<AsyncValue<List<Data>?>>(liveVehicleProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        _allVehicles = next.value!;
        state = _allVehicles; // Update the state with new data
      }
    });
  }

  Future<void> _init() async {
    // Load initial data
    final liveVehicle = await ref.read(liveVehicleProvider.future);
    if (liveVehicle != null) {
      _allVehicles = liveVehicle;
      state = _allVehicles; // Initially display all vehicles
    }
  }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      state = _allVehicles; // Reset to all vehicles if query is empty
    } else {
      state = _allVehicles.where((vehicle) {
        return (vehicle.rto?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               (vehicle.id?.toString().contains(query) ?? false);
      }).toList();
    }
  }
}

// Provider for the VehicleSearchNotifier
final vehicleSearchProvider =
    StateNotifierProvider<VehicleSearchNotifier, List<Data>>((ref) {
  return VehicleSearchNotifier(ref);
});


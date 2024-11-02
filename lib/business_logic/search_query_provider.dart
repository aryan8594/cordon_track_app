// vehicle_providers.dart

import 'package:cordon_track_app/data/data_providers/live_vehicle_provider.dart';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final isSearchVisibleProvider = StateProvider<bool>((ref) => false);


final filteredVehiclesProvider = Provider<List<Data>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final liveVehicleData = ref.watch(liveVehicleProvider);

  // Check if data is still loading or if an error occurred
  return liveVehicleData.when(
    data: (data) {
      // If query is empty, return an empty list to clear the filtered list
      if (query.isEmpty) return [];

      return data!.where((vehicle) {
        final rtoMatch = vehicle.rto?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final idMatch = vehicle.id?.toString().toLowerCase().contains(query.toLowerCase()) ?? false;
        return rtoMatch || idMatch;
      }).toList();
    },
    loading: () => [], // Return an empty list while loading
    error: (e, _) {
      print("Error loading vehicle data: $e");
      return []; // Return an empty list if there's an error
    },
  );
});

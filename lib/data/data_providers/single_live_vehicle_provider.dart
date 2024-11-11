
import 'dart:async';

import 'package:cordon_track_app/data/models/single_live_vehicle_model.dart';
import 'package:cordon_track_app/data/repositories/single_live_vehicle_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage the selected vehicle ID
final selectedVehicleIdProvider = StateProvider<String?>((ref) => null);


// Fetch vehicle data from API using the repository every 5 seconds
final singleLiveVehicleProvider = StreamProvider.autoDispose.family<SingleLiveVehicleModel?, String>((ref, selectedVehicleID) {
  final repository = SingleLiveVehicleRepository();
  final controller = StreamController<SingleLiveVehicleModel?>();

  // Function to fetch and add data to the controller
  Future<void> fetchData() async {
    try {
      final data = await repository.fetchLiveVehicleData(selectedVehicleID);
      controller.add(data);
    } catch (error) {
      if (controller == null) {
        controller.addError(error);
      }
    }
  }

  // Initial fetch
  fetchData();

  // Create a periodic timer
  final timer = Timer.periodic(const Duration(seconds: 5), (_) {
    fetchData();
  });

  // Ensure timer and stream controller are cleaned up when disposed
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
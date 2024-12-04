import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/repositories/live_vehicle_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cordon_track_app/data/models/live_vehicle_model.dart';

// Fetch vehicle data from API using the repository
final liveVehicleProvider = FutureProvider.autoDispose<List<Data>?>((ref) async {
  final token = ref.watch(tokenProvider.notifier).state;
  return await LiveVehicleRepository(ref).fetchLiveVehicleData();
});

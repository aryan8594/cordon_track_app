import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:cordon_track_app/data/repositories/vehicle_history_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyVehicleRepositoryProvider = Provider<HistoryVehicleRepository>((ref) {
  return HistoryVehicleRepository(ref);
});

// FutureProvider to fetch vehicle history data
final historyDataProvider = FutureProvider.family<VehicleHistoryModel?, String>((ref, vehicleId,) async {
  final repository = ref.read(historyVehicleRepositoryProvider);

  final fromDate = DateTime.now().subtract(const Duration(days: 1)); // Example: 1 day ago
  final toDate = DateTime.now();

  return repository.fetchVehicleHistory(vehicleId, fromDate, toDate);
});
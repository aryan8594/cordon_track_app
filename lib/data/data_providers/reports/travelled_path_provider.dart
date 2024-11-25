import 'dart:developer';

import 'package:cordon_track_app/data/models/reports/travelled_path_model.dart';
import 'package:cordon_track_app/data/repositories/reports/travelled_path_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Repository Provider
final travelledPathRepositoryProvider = Provider<TravelledPathRepository>((ref) {
  return TravelledPathRepository();
});

/// State Notifier for managing API logic
class TravelledPathNotifier extends StateNotifier<AsyncValue<TravelledPathModel>> {
  final TravelledPathRepository repository;

  TravelledPathNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchTravelledPath({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String timeDifference,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchTravelledPath(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
        timeDifference: timeDifference,
      );
      state = AsyncValue.data(result);
      log("Travelled Path fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Travelled Path: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final travelledPathProvider =
    StateNotifierProvider<TravelledPathNotifier, AsyncValue<TravelledPathModel>>(
  (ref) {
    final repository = ref.read(travelledPathRepositoryProvider);
    return TravelledPathNotifier(repository);
  },
);

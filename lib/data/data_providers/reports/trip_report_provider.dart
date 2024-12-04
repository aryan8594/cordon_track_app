import 'dart:developer';

import 'package:cordon_track_app/data/models/reports/trip_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/trip_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final tripReportRepositoryProvider = Provider<TripReportRepository>((ref) {
  return TripReportRepository(ref);
});
/// State Notifier for managing API logic
class TripReportNotifier extends StateNotifier<AsyncValue<TripReportModel>> {
  final TripReportRepository repository;

  TripReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchTripReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchTripReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(result);
      log("Trip Report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Trip Report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final tripReportProvider =
    StateNotifierProvider<TripReportNotifier, AsyncValue<TripReportModel>>(
  (ref) {
    final repository = ref.read(tripReportRepositoryProvider);
    return TripReportNotifier(repository);
  },
);

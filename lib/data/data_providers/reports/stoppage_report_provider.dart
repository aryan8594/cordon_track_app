import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/stoppage_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/stoppage_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final stoppageReportRepositoryProvider = Provider<StoppageReportRepository>((ref) {
  return StoppageReportRepository(ref);
});

/// State Notifier for managing API logic
class StoppageReportNotifier extends StateNotifier<AsyncValue<StoppageReportModel>> {
  final StoppageReportRepository repository;

  StoppageReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchStoppageReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String time,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchStoppageReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
        time: time,
      );
      state = AsyncValue.data(result);
      log("Stoppage Report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Stoppage Report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final stoppageReportProvider =
    StateNotifierProvider<StoppageReportNotifier, AsyncValue<StoppageReportModel>>(
  (ref) {
    final repository = ref.read(stoppageReportRepositoryProvider);
    return StoppageReportNotifier(repository);
  },
);

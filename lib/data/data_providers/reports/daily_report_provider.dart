import 'dart:developer';

import 'package:cordon_track_app/data/models/reports/daily_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/daily_report_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final dailyReportRepositoryProvider = Provider<DailyReportRepository>((ref) {
  return DailyReportRepository();
});

/// State Notifier for managing API logic
class DailyReportNotifier extends StateNotifier<AsyncValue<DailyReportModel>> {
  final DailyReportRepository repository;

  DailyReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchDailyReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchDailyReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(result);
      log("Daily Report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching Daily Report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the StateNotifier
final dailyReportProvider =
    StateNotifierProvider<DailyReportNotifier, AsyncValue<DailyReportModel>>(
  (ref) {
    final repository = ref.read(dailyReportRepositoryProvider);
    return DailyReportNotifier(repository);
  },
);

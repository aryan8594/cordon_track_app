import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/idle_report_model.dart';
import 'package:cordon_track_app/data/repositories/reports/idle_report_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository Provider
final idleReportRepositoryProvider = Provider<IdleReportRepository>((ref) {
  return IdleReportRepository(ref);
});

/// StateNotifier for managing API logic
class IdleReportNotifier extends StateNotifier<AsyncValue<IdleReportModel>> {
  final IdleReportRepository repository;

  IdleReportNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchIdleReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String time,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.fetchIdleReport(
        id: id,
        fromDate: fromDate,
        toDate: toDate,
        time: time,
      );
      state = AsyncValue.data(result);
      log("Idle report fetched successfully.");
    } catch (error, stackTrace) {
      log("Error fetching idle report: $error", stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// StateNotifierProvider
final idleReportProvider =
    StateNotifierProvider<IdleReportNotifier, AsyncValue<IdleReportModel>>(
  (ref) {
    final repository = ref.read(idleReportRepositoryProvider);
    return IdleReportNotifier(repository);
  },
);

// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/geofence_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class GeofenceReportRepository {
  final Ref ref;
  GeofenceReportRepository(this.ref);
  Future<GeofenceReportModel> fetchGeofenceReport({
    required String id,
    required String reportType,
    required DateTime fromDate,
    required DateTime toDate,

  }) async {
    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/geofence_report?id=${id}&report_type=${reportType}&from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Geofence report API fetched.");
      final jsonData = jsonDecode(response.body);
      return GeofenceReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch Geofence report: ${response.reasonPhrase}");
    }
  }
}

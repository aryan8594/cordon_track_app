// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/trip_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class TripReportRepository {
  final String start = "0";
  final String length = "100";
  final String draw = "5";
  final Ref ref;
  TripReportRepository(this.ref);

  Future<dynamic> fetchTripReport({

    required DateTime fromDate,
    required DateTime toDate,
    required String id,
  }) async {
    String token = ref.watch(tokenProvider.notifier).state;

    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/Trip?start=${start}&length=${length}&from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}&draw=${draw}&id=${id}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log('Trip reports API fetched');
      final jsonData = jsonDecode(response.body);
      return TripReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch trip report: ${response.reasonPhrase}");
    }
  }
}

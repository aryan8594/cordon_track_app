import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/distance_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class DistanceReportRepository {
  final String start = "0";
  final String length = "100";
  final String draw = "5";
  final Ref ref;
  DistanceReportRepository(this.ref);
  Future<dynamic> fetchDistanceReport({

    required String id,
    required DateTime fromDate,
    required DateTime toDate,

  }) async {
    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/distance?start=${start}&length=${length}&id=${id}&from_date=${fromDate.toString()}&to_date=${toDate.toString()}&draw=${draw}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Distance report api fetched");
      final jsonData = jsonDecode(response.body);
      log(response.body);
      return DistanceReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch distance report: ${response.statusCode} ${response.reasonPhrase}");
    }
  }
}

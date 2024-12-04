// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/alerts_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AlertsRepository {
  final String filter = "panic_alert";
  final String draw = "2";
  final String page = "0";
  final String start = "0";
  final String length = "10";

  final Ref ref;
  AlertsRepository(this.ref);

  Future<AlertsModel> fetchAlerts() async {
    String token = ref.watch(tokenProvider.notifier).state;

    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/datatable/alerts?filter=${filter}&draw=${draw}&page=${page}&start=${start}&length=${length}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Alerts API detched.");
      final jsonData = jsonDecode(response.body);
      return AlertsModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch Alerts API: ${response.reasonPhrase}");
    }
  }
}

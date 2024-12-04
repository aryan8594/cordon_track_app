import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class DashboardRepository  {
  final String apiUrl = 'https://cordontrack.com/api/v1/common/count';
  // final String token = '8fce96fe1288a2c2b5affeba94201267';
  final Ref ref;
  DashboardRepository(this.ref);
  
  Future<dynamic> fetchDashboardData() async {
    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      // ignore: unnecessary_string_interpolations
      'Token': '$token',
    });

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      log("Dashboard Data fetched");
      final jsonData = jsonDecode(response.body);
      return DashboardModel.fromJson(jsonData);
      
    } else {
      log('Failed to load vehicles');
      return null;
    }
  }
}

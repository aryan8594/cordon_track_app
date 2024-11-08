import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/models/live_vehicle_model.dart';
import 'package:http/http.dart' as http;

class LiveVehicleRepository  {
  final String apiUrl = 'https://cordontrack.com/api/v1/vehicle/live_vehicles_new?filter=&ids=';
  final String token = '8fce96fe1288a2c2b5affeba94201267';

  Future<List<Data>?> fetchLiveVehicleData() async {
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Token': '$token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      log("Live Vehile Data fetched");
      LiveVehicleModel liveVehicle = LiveVehicleModel.fromJson(json);
      return liveVehicle.data;
      
    } else {
      print('Failed to load vehicles');
      return null;
    }
  }
}

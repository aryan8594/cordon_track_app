import 'dart:convert';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:http/http.dart' as http;

class HistoryVehicleRepository{
    final String token = '8fce96fe1288a2c2b5affeba94201267';
Future<VehicleHistoryModel?> fetchVehicleHistory( String slectedVehicleID, DateTime fromDate, DateTime toDate) async{
  try{
    var VehicleHistoryURL = Uri.parse('https://cordontrack.com/api/v1/vehicle/route_playback_new');
    final map = <String, dynamic>{};
    map['id'] = '$slectedVehicleID';
    map['from_date'] = '$fromDate';
    map['to_date'] = '$toDate';

    var response = await http.post(
      VehicleHistoryURL,
      headers: {
      'Token': '$token',},
      body: map,

    );

    if (response.statusCode == 200) {
        print('Data Fetched From API for VehicleSpecificHistory');
        return VehicleHistoryModel.fromJson(jsonDecode(response.body));
        
    } else {
      print('Failed to load VehicleSpecificHistory');
      return null;
    }

  }catch (e) {
      print("Exception caught: $e");
      return null;
  }
}
}
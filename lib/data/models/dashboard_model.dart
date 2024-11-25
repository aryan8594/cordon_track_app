class DashboardModel {
  List<Vehicles>? vehicles;
  bool? status;
  String? message;
  Data? data;

  DashboardModel({this.vehicles, this.status, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicles.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Vehicles {
  String? id;
  String? rto;
  String? vType;
  String? vCategory;
  String? location;
  String? latitude;
  String? longitude;
  String? direction;
  String? datetime;
  String? speed;
  String? gpsStatus;
  String? gsmSingnalStrength;
  String? acStatus;
  String? acSince;
  String? fuelValue;
  String? idleSince;
  String? stoppageSince;
  String? geoSince;
  String? ignitionStatus;
  String? powerStatus;
  String? panicStatus;
  String? caseOpenSwitchStatus;
  String? doorStatus;
  String? internalBatteryVoltage;
  String? externalBatteryVoltage;
  String? acumulatedDistance;
  String? distanceToday;
  String? geoStatus;
  String? remarks;
  String? vehicleGroup;
  String? citygeoStatus;
  String? citygeoSince;
  String? geoName;

  Vehicles(
      {this.id,
      this.rto,
      this.vType,
      this.vCategory,
      this.location,
      this.latitude,
      this.longitude,
      this.direction,
      this.datetime,
      this.speed,
      this.gpsStatus,
      this.gsmSingnalStrength,
      this.acStatus,
      this.acSince,
      this.fuelValue,
      this.idleSince,
      this.stoppageSince,
      this.geoSince,
      this.ignitionStatus,
      this.powerStatus,
      this.panicStatus,
      this.caseOpenSwitchStatus,
      this.doorStatus,
      this.internalBatteryVoltage,
      this.externalBatteryVoltage,
      this.acumulatedDistance,
      this.distanceToday,
      this.geoStatus,
      this.remarks,
      this.vehicleGroup,
      this.citygeoStatus,
      this.citygeoSince,
      this.geoName});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rto = json['rto'];
    vType = json['v_type'];
    vCategory = json['v_category'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    direction = json['direction'];
    datetime = json['datetime'];
    speed = json['speed'];
    gpsStatus = json['gps_status'];
    gsmSingnalStrength = json['gsm_singnal_strength'];
    acStatus = json['ac_status'];
    acSince = json['ac_since'];
    fuelValue = json['fuel_value'];
    idleSince = json['idle_since'];
    stoppageSince = json['stoppage_since'];
    geoSince = json['geo_since'];
    ignitionStatus = json['ignition_status'];
    powerStatus = json['power_status'];
    panicStatus = json['panic_status'];
    caseOpenSwitchStatus = json['case_open_switch_status'];
    doorStatus = json['door_status'];
    internalBatteryVoltage = json['internal_battery_voltage'];
    externalBatteryVoltage = json['external_battery_voltage'];
    acumulatedDistance = json['acumulated_distance'];
    distanceToday = json['distance_today'];
    geoStatus = json['geo_status'];
    remarks = json['remarks'];
    vehicleGroup = json['vehicle_group'];
    citygeoStatus = json['citygeo_status'];
    citygeoSince = json['citygeo_since'];
    geoName = json['geo_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rto'] = this.rto;
    data['v_type'] = this.vType;
    data['v_category'] = this.vCategory;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['direction'] = this.direction;
    data['datetime'] = this.datetime;
    data['speed'] = this.speed;
    data['gps_status'] = this.gpsStatus;
    data['gsm_singnal_strength'] = this.gsmSingnalStrength;
    data['ac_status'] = this.acStatus;
    data['ac_since'] = this.acSince;
    data['fuel_value'] = this.fuelValue;
    data['idle_since'] = this.idleSince;
    data['stoppage_since'] = this.stoppageSince;
    data['geo_since'] = this.geoSince;
    data['ignition_status'] = this.ignitionStatus;
    data['power_status'] = this.powerStatus;
    data['panic_status'] = this.panicStatus;
    data['case_open_switch_status'] = this.caseOpenSwitchStatus;
    data['door_status'] = this.doorStatus;
    data['internal_battery_voltage'] = this.internalBatteryVoltage;
    data['external_battery_voltage'] = this.externalBatteryVoltage;
    data['acumulated_distance'] = this.acumulatedDistance;
    data['distance_today'] = this.distanceToday;
    data['geo_status'] = this.geoStatus;
    data['remarks'] = this.remarks;
    data['vehicle_group'] = this.vehicleGroup;
    data['citygeo_status'] = this.citygeoStatus;
    data['citygeo_since'] = this.citygeoSince;
    data['geo_name'] = this.geoName;
    return data;
  }
}

class Data {
  String? vehicleCount;
  String? trackingVehicleCount;
  String? vehicleAssignCount;
  String? driverCount;
  int? panicCount;
  int? runningVehicleCount;
  int? idleVehicleCount;
  int? insideGeofenceCount;
  int? speed30;
  int? overSpeedCount;
  int? speed80;
  int? nogpsCoverageCount;
  int? nogsmCount;
  int? lowBatteryCount;
  int? disconnected;

  Data(
      {this.vehicleCount,
      this.trackingVehicleCount,
      this.vehicleAssignCount,
      this.driverCount,
      this.panicCount,
      this.runningVehicleCount,
      this.idleVehicleCount,
      this.insideGeofenceCount,
      this.speed30,
      this.overSpeedCount,
      this.speed80,
      this.nogpsCoverageCount,
      this.nogsmCount,
      this.lowBatteryCount,
      this.disconnected});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleCount = json['vehicle_count'];
    trackingVehicleCount = json['tracking_vehicle_count'];
    vehicleAssignCount = json['vehicle_assign_count'];
    driverCount = json['driver_count'];
    panicCount = json['panic_count'];
    runningVehicleCount = json['running_vehicle_count'];
    idleVehicleCount = json['idle_vehicle_count'];
    insideGeofenceCount = json['inside_geofence_count'];
    speed30 = json['speed_30'];
    overSpeedCount = json['over_speed_count'];
    speed80 = json['speed_80'];
    nogpsCoverageCount = json['nogps_coverage_count'];
    nogsmCount = json['nogsm_count'];
    lowBatteryCount = json['low_battery_count'];
    disconnected = json['disconnected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_count'] = this.vehicleCount;
    data['tracking_vehicle_count'] = this.trackingVehicleCount;
    data['vehicle_assign_count'] = this.vehicleAssignCount;
    data['driver_count'] = this.driverCount;
    data['panic_count'] = this.panicCount;
    data['running_vehicle_count'] = this.runningVehicleCount;
    data['idle_vehicle_count'] = this.idleVehicleCount;
    data['inside_geofence_count'] = this.insideGeofenceCount;
    data['speed_30'] = this.speed30;
    data['over_speed_count'] = this.overSpeedCount;
    data['speed_80'] = this.speed80;
    data['nogps_coverage_count'] = this.nogpsCoverageCount;
    data['nogsm_count'] = this.nogsmCount;
    data['low_battery_count'] = this.lowBatteryCount;
    data['disconnected'] = this.disconnected;
    return data;
  }
}

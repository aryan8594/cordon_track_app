class VehicleHistoryModel {
  bool? status;
  String? message;
  Data? data;

  VehicleHistoryModel({this.status, this.message, this.data});

  VehicleHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? type;
  String? rto;
  String? uName;
  String? dName;
  List<History>? history;
  double? odometerStart;
  double? odometerEnd;
  double? distance;

  Data(
      {this.id,
      this.type,
      this.rto,
      this.uName,
      this.dName,
      this.history,
      this.odometerStart,
      this.odometerEnd,
      this.distance});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    rto = json['rto'];
    uName = json['u_name'];
    dName = json['d_name'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
    odometerStart = json['odometer_start'];
    odometerEnd = json['odometer_end'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['rto'] = this.rto;
    data['u_name'] = this.uName;
    data['d_name'] = this.dName;
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    data['odometer_start'] = this.odometerStart;
    data['odometer_end'] = this.odometerEnd;
    data['distance'] = this.distance;
    return data;
  }
}

class History {
  String? id;
  String? lat;
  String? lng;
  String? datetime;
  String? acumulatedDistance;
  String? speed;
  String? direction;
  String? location;
  String? ignitionStatus;
  int? duration;
  String? ptype;

  History(
      {this.id,
      this.lat,
      this.lng,
      this.datetime,
      this.acumulatedDistance,
      this.speed,
      this.direction,
      this.location,
      this.ignitionStatus,
      this.duration,
      this.ptype});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lng = json['lng'];
    datetime = json['datetime'];
    acumulatedDistance = json['acumulated_distance'];
    speed = json['speed'];
    direction = json['direction'];
    location = json['location'];
    ignitionStatus = json['ignition_status'];
    duration = json['duration'];
    ptype = json['ptype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['datetime'] = this.datetime;
    data['acumulated_distance'] = this.acumulatedDistance;
    data['speed'] = this.speed;
    data['direction'] = this.direction;
    data['location'] = this.location;
    data['ignition_status'] = this.ignitionStatus;
    data['duration'] = this.duration;
    data['ptype'] = this.ptype;
    return data;
  }
}

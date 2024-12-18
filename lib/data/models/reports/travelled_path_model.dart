// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TravelledPathModel {
  String? id;
  String? type;
  String? rto;
  String? uName;
  String? dName;
  String? startOdometer;
  List<Data>? data;
  String? draw;
  String? recordsFiltered;
  String? recordsTotal;

  TravelledPathModel(
      {this.id,
      this.type,
      this.rto,
      this.uName,
      this.dName,
      this.startOdometer,
      this.data,
      this.draw,
      this.recordsFiltered,
      this.recordsTotal});

  TravelledPathModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    rto = json['rto'];
    uName = json['u_name'];
    dName = json['d_name'];
    startOdometer = json['start_odometer'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['rto'] = this.rto;
    data['u_name'] = this.uName;
    data['d_name'] = this.dName;
    data['start_odometer'] = this.startOdometer;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['draw'] = this.draw;
    data['recordsFiltered'] = this.recordsFiltered;
    data['recordsTotal'] = this.recordsTotal;
    return data;
  }
}

class Data {
  String? id;
  String? datetime;
  String? acumulatedDistance;
  String? speed;
  String? latitude;
  String? longitude;
  String? ignitionStatus;
  String? location;
  String? geoName;
  String? geoStatus;
  String? startOdometer;

  Data(
      {this.id,
      this.datetime,
      this.acumulatedDistance,
      this.speed,
      this.latitude,
      this.longitude,
      this.ignitionStatus,
      this.location,
      this.geoName,
      this.geoStatus,
      this.startOdometer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    datetime = json['datetime'];
    acumulatedDistance = json['acumulated_distance'];
    speed = json['speed'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ignitionStatus = json['ignition_status'];
    location = json['location'];
    geoName = json['geo_name'];
    geoStatus = json['geo_status'];
    startOdometer = json['start_odometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['datetime'] = this.datetime;
    data['acumulated_distance'] = this.acumulatedDistance;
    data['speed'] = this.speed;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['ignition_status'] = this.ignitionStatus;
    data['location'] = this.location;
    data['geo_name'] = this.geoName;
    data['geo_status'] = this.geoStatus;
    data['start_odometer'] = this.startOdometer;
    return data;
  }
}

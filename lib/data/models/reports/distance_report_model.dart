class DistanceReportModel {
  List<Data>? data;
  String? draw;
  int? recordsFiltered;
  int? recordsTotal;
  List<Res>? res;

  DistanceReportModel(
      {this.data,
      this.draw,
      this.recordsFiltered,
      this.recordsTotal,
      this.res});

  DistanceReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
    if (json['res'] != null) {
      res = <Res>[];
      json['res'].forEach((v) {
        res!.add(new Res.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['draw'] = this.draw;
    data['recordsFiltered'] = this.recordsFiltered;
    data['recordsTotal'] = this.recordsTotal;
    if (this.res != null) {
      data['res'] = this.res!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? rto;
  String? date;
  String? distance;
  String? locationStart;
  String? locationEnd;
  String? odometerStart;
  String? odometerEnd;

  Data(
      {this.rto,
      this.date,
      this.distance,
      this.locationStart,
      this.locationEnd,
      this.odometerStart,
      this.odometerEnd});

  Data.fromJson(Map<String, dynamic> json) {
    rto = json['rto'];
    date = json['date'];
    distance = json['distance'];
    locationStart = json['location_start'];
    locationEnd = json['location_end'];
    odometerStart = json['odometer_start'];
    odometerEnd = json['odometer_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rto'] = this.rto;
    data['date'] = this.date;
    data['distance'] = this.distance;
    data['location_start'] = this.locationStart;
    data['location_end'] = this.locationEnd;
    data['odometer_start'] = this.odometerStart;
    data['odometer_end'] = this.odometerEnd;
    return data;
  }
}

class Res {
  String? vehicleId;
  String? rto;
  String? date;
  String? ignitionStart;
  String? ignitionEnd;
  String? locationStart;
  String? locationEnd;
  String? odometerStart;
  String? odometerEnd;

  Res(
      {this.vehicleId,
      this.rto,
      this.date,
      this.ignitionStart,
      this.ignitionEnd,
      this.locationStart,
      this.locationEnd,
      this.odometerStart,
      this.odometerEnd});

  Res.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    rto = json['rto'];
    date = json['date'];
    ignitionStart = json['ignition_start'];
    ignitionEnd = json['ignition_end'];
    locationStart = json['location_start'];
    locationEnd = json['location_end'];
    odometerStart = json['odometer_start'];
    odometerEnd = json['odometer_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['rto'] = this.rto;
    data['date'] = this.date;
    data['ignition_start'] = this.ignitionStart;
    data['ignition_end'] = this.ignitionEnd;
    data['location_start'] = this.locationStart;
    data['location_end'] = this.locationEnd;
    data['odometer_start'] = this.odometerStart;
    data['odometer_end'] = this.odometerEnd;
    return data;
  }
}

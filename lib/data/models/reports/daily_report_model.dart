// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class DailyReportModel {
  List<Data>? data;
  String? draw;
  num? recordsFiltered;
  num? recordsTotal;
  String? id;
  String? type;
  String? rto;
  String? uName;
  String? dName;

  DailyReportModel(
      {this.data,
      this.draw,
      this.recordsFiltered,
      this.recordsTotal,
      this.id,
      this.type,
      this.rto,
      this.uName,
      this.dName});

  DailyReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
    id = json['id'];
    type = json['type'];
    rto = json['rto'];
    uName = json['u_name'];
    dName = json['d_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['draw'] = this.draw;
    data['recordsFiltered'] = this.recordsFiltered;
    data['recordsTotal'] = this.recordsTotal;
    data['id'] = this.id;
    data['type'] = this.type;
    data['rto'] = this.rto;
    data['u_name'] = this.uName;
    data['d_name'] = this.dName;
    return data;
  }
}

class Data {
  String? vehicleId;
  String? date;
  String? rto;
  String? ignitionStart;
  String? ignitionEnd;
  String? locationStart;
  String? locationEnd;
  num? odometerStart;
  num? odometerEnd;
  String? avgSpeed;
  String? maxSpeed;
  String? overspeedCount;
  String? harshAccelerationCount;
  String? harshBreakingCount;
  String? overTurningCount;
  String? overspeedTime;
  String? runningTime;
  String? idleTime;
  String? stoppageTime;
  String? geoinTime;
  String? geooutTime;
  String? citygeoinTime;
  String? citygeooutTime;
  String? aconTime;
  String? aconidleTime;

  Data(
      {this.vehicleId,
      this.date,
      this.rto,
      this.ignitionStart,
      this.ignitionEnd,
      this.locationStart,
      this.locationEnd,
      this.odometerStart,
      this.odometerEnd,
      this.avgSpeed,
      this.maxSpeed,
      this.overspeedCount,
      this.harshAccelerationCount,
      this.harshBreakingCount,
      this.overTurningCount,
      this.overspeedTime,
      this.runningTime,
      this.idleTime,
      this.stoppageTime,
      this.geoinTime,
      this.geooutTime,
      this.citygeoinTime,
      this.citygeooutTime,
      this.aconTime,
      this.aconidleTime});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    date = json['date'];
    rto = json['rto'];
    ignitionStart = json['ignition_start'];
    ignitionEnd = json['ignition_end'];
    locationStart = json['location_start'];
    locationEnd = json['location_end'];
    odometerStart = json['odometer_start'];
    odometerEnd = json['odometer_end'];
    avgSpeed = json['avg_speed'];
    maxSpeed = json['max_speed'];
    overspeedCount = json['overspeed_count'];
    harshAccelerationCount = json['harsh_acceleration_count'];
    harshBreakingCount = json['harsh_breaking_count'];
    overTurningCount = json['over_turning_count'];
    overspeedTime = json['overspeed_time'];
    runningTime = json['running_time'];
    idleTime = json['idle_time'];
    stoppageTime = json['stoppage_time'];
    geoinTime = json['geoin_time'];
    geooutTime = json['geoout_time'];
    citygeoinTime = json['citygeoin_time'];
    citygeooutTime = json['citygeoout_time'];
    aconTime = json['acon_time'];
    aconidleTime = json['aconidle_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['date'] = this.date;
    data['rto'] = this.rto;
    data['ignition_start'] = this.ignitionStart;
    data['ignition_end'] = this.ignitionEnd;
    data['location_start'] = this.locationStart;
    data['location_end'] = this.locationEnd;
    data['odometer_start'] = this.odometerStart;
    data['odometer_end'] = this.odometerEnd;
    data['avg_speed'] = this.avgSpeed;
    data['max_speed'] = this.maxSpeed;
    data['overspeed_count'] = this.overspeedCount;
    data['harsh_acceleration_count'] = this.harshAccelerationCount;
    data['harsh_breaking_count'] = this.harshBreakingCount;
    data['over_turning_count'] = this.overTurningCount;
    data['overspeed_time'] = this.overspeedTime;
    data['running_time'] = this.runningTime;
    data['idle_time'] = this.idleTime;
    data['stoppage_time'] = this.stoppageTime;
    data['geoin_time'] = this.geoinTime;
    data['geoout_time'] = this.geooutTime;
    data['citygeoin_time'] = this.citygeoinTime;
    data['citygeoout_time'] = this.citygeooutTime;
    data['acon_time'] = this.aconTime;
    data['aconidle_time'] = this.aconidleTime;
    return data;
  }
}

class DistanceReportModel {
  List<Data>? data;
  String? draw;
  int? recordsFiltered;
  int? recordsTotal;

  DistanceReportModel(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? rto;
  String? date;
  String? odometerStart;
  String? locationStart;
  String? odometerEnd;
  String? locationEnd;
  String? distance;

  Data(
      {this.rto,
      this.date,
      this.odometerStart,
      this.locationStart,
      this.odometerEnd,
      this.locationEnd,
      this.distance});

  Data.fromJson(Map<String, dynamic> json) {
    rto = json['rto'];
    date = json['date'];
    odometerStart = json['odometer_start'];
    locationStart = json['location_start'];
    odometerEnd = json['odometer_end'];
    locationEnd = json['location_end'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rto'] = this.rto;
    data['date'] = this.date;
    data['odometer_start'] = this.odometerStart;
    data['location_start'] = this.locationStart;
    data['odometer_end'] = this.odometerEnd;
    data['location_end'] = this.locationEnd;
    data['distance'] = this.distance;
    return data;
  }
}

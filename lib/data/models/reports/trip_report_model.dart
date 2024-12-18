// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TripReportModel {
  String? id;
  String? type;
  String? rto;
  String? uName;
  String? dName;
  List<Data>? data;
  String? draw;
  int? recordsFiltered;
  int? recordsTotal;

  TripReportModel(
      {this.id,
      this.type,
      this.rto,
      this.uName,
      this.dName,
      this.data,
      this.draw,
      this.recordsFiltered,
      this.recordsTotal});

  TripReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    rto = json['rto'];
    uName = json['u_name'];
    dName = json['d_name'];
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
  int? tripNo;
  String? startDatetime;
  String? startLocation;
  String? endDatetime;
  String? endLocation;
  int? duration;
  double? distance;

  Data(
      {this.tripNo,
      this.startDatetime,
      this.startLocation,
      this.endDatetime,
      this.endLocation,
      this.duration,
      this.distance});

  Data.fromJson(Map<String, dynamic> json) {
    tripNo = json['trip_no'];
    startDatetime = json['start_datetime'];
    startLocation = json['start_location'];
    endDatetime = json['end_datetime'];
    endLocation = json['end_location'];
    duration = json['duration'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_no'] = this.tripNo;
    data['start_datetime'] = this.startDatetime;
    data['start_location'] = this.startLocation;
    data['end_datetime'] = this.endDatetime;
    data['end_location'] = this.endLocation;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

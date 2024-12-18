// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class StoppageReportModel {
  String? id;
  String? type;
  String? rto;
  String? uName;
  String? dName;
  List<Data>? data;
  String? draw;
  int? recordsFiltered;
  int? recordsTotal;

  StoppageReportModel(
      {this.id,
      this.type,
      this.rto,
      this.uName,
      this.dName,
      this.data,
      this.draw,
      this.recordsFiltered,
      this.recordsTotal});

  StoppageReportModel.fromJson(Map<String, dynamic> json) {
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
  String? startDatetime;
  String? endDatetime;
  int? stoppageTime;
  String? location;

  Data(
      {this.startDatetime, this.endDatetime, this.stoppageTime, this.location});

  Data.fromJson(Map<String, dynamic> json) {
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    stoppageTime = json['stoppage_time'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_datetime'] = this.startDatetime;
    data['end_datetime'] = this.endDatetime;
    data['stoppage_time'] = this.stoppageTime;
    data['location'] = this.location;
    return data;
  }
}

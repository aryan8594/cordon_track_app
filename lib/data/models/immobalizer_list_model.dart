class ImmobalizerListModel {
  List<Data>? data;
  String? draw;
  String? recordsFiltered;
  String? recordsTotal;

  ImmobalizerListModel(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

  ImmobalizerListModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? event;
  String? rto;
  String? vehicleId;
  String? userId;
  String? imei;
  String? status;
  String? date;
  String? command;

  Data(
      {this.id,
      this.event,
      this.rto,
      this.vehicleId,
      this.userId,
      this.imei,
      this.status,
      this.date,
      this.command});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    rto = json['rto'];
    vehicleId = json['vehicle_id'];
    userId = json['user_id'];
    imei = json['imei'];
    status = json['status'];
    date = json['date'];
    command = json['command'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event'] = this.event;
    data['rto'] = this.rto;
    data['vehicle_id'] = this.vehicleId;
    data['user_id'] = this.userId;
    data['imei'] = this.imei;
    data['status'] = this.status;
    data['date'] = this.date;
    data['command'] = this.command;
    return data;
  }
}

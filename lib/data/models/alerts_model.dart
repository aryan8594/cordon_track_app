class AlertsModel {
  List<Data>? data;
  String? draw;
  int? recordsFiltered;
  int? recordsTotal;

  AlertsModel({this.data, this.draw, this.recordsFiltered, this.recordsTotal});

  AlertsModel.fromJson(Map<String, dynamic> json) {
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
  String? vehicleId;
  String? rto;
  String? datetime;
  String? alertType;
  String? mobile;
  String? email;
  String? message;
  String? description;
  String? msgStatus;
  String? emailStatus;
  String? notificationStatus;

  Data(
      {this.id,
      this.vehicleId,
      this.rto,
      this.datetime,
      this.alertType,
      this.mobile,
      this.email,
      this.message,
      this.description,
      this.msgStatus,
      this.emailStatus,
      this.notificationStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    rto = json['rto'];
    datetime = json['datetime'];
    alertType = json['alert_type'];
    mobile = json['mobile'];
    email = json['email'];
    message = json['message'];
    description = json['description'];
    msgStatus = json['msg_status'];
    emailStatus = json['email_status'];
    notificationStatus = json['notification_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_id'] = this.vehicleId;
    data['rto'] = this.rto;
    data['datetime'] = this.datetime;
    data['alert_type'] = this.alertType;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['message'] = this.message;
    data['description'] = this.description;
    data['msg_status'] = this.msgStatus;
    data['email_status'] = this.emailStatus;
    data['notification_status'] = this.notificationStatus;
    return data;
  }
}

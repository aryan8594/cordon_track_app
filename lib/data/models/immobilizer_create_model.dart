// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ImmobilizerCreateModel {
  bool? status;
  String? message;
  int? data;
  Command? command;

  ImmobilizerCreateModel({this.status, this.message, this.data, this.command});

  ImmobilizerCreateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    command =
        json['command'] != null ? new Command.fromJson(json['command']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    if (this.command != null) {
      data['command'] = this.command!.toJson();
    }
    return data;
  }
}

class Command {
  String? scheduleTime;
  String? scheduleName;
  String? event;
  String? status;
  int? imoId;
  String? imei;
  String? vehicleId;
  String? deviceModel;
  String? message;

  Command(
      {this.scheduleTime,
      this.scheduleName,
      this.event,
      this.status,
      this.imoId,
      this.imei,
      this.vehicleId,
      this.deviceModel,
      this.message});

  Command.fromJson(Map<String, dynamic> json) {
    scheduleTime = json['schedule_time'];
    scheduleName = json['schedule_name'];
    event = json['event'];
    status = json['status'];
    imoId = json['imo_id'];
    imei = json['imei'];
    vehicleId = json['vehicle_id'];
    deviceModel = json['device_model'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_time'] = this.scheduleTime;
    data['schedule_name'] = this.scheduleName;
    data['event'] = this.event;
    data['status'] = this.status;
    data['imo_id'] = this.imoId;
    data['imei'] = this.imei;
    data['vehicle_id'] = this.vehicleId;
    data['device_model'] = this.deviceModel;
    data['message'] = this.message;
    return data;
  }
}

class GeofenceReportModel {
  bool? status;
  String? message;
  Data? data;

  GeofenceReportModel({this.status, this.message, this.data});

  GeofenceReportModel.fromJson(Map<String, dynamic> json) {
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
  Response? response;
  List<DeviceLog>? deviceLog;
  List<History>? history;

  Data({this.response, this.deviceLog, this.history});

  Data.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    if (json['device_log'] != null) {
      deviceLog = <DeviceLog>[];
      json['device_log'].forEach((v) {
        deviceLog!.add(new DeviceLog.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.deviceLog != null) {
      data['device_log'] = this.deviceLog!.map((v) => v.toJson()).toList();
    }
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? alertType;
  String? reportType;
  List<DeviceLog1>? deviceLog1;
  List<DeviceLog2>? deviceLog2;

  Response({this.alertType, this.reportType, this.deviceLog1, this.deviceLog2});

  Response.fromJson(Map<String, dynamic> json) {
    alertType = json['alert_type'];
    reportType = json['report_type'];
    if (json['device_log1'] != null) {
      deviceLog1 = <DeviceLog1>[];
      json['device_log1'].forEach((v) {
        deviceLog1!.add(new DeviceLog1.fromJson(v));
      });
    }
    if (json['device_log2'] != null) {
      deviceLog2 = <DeviceLog2>[];
      json['device_log2'].forEach((v) {
        deviceLog2!.add(new DeviceLog2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alert_type'] = this.alertType;
    data['report_type'] = this.reportType;
    if (this.deviceLog1 != null) {
      data['device_log1'] = this.deviceLog1!.map((v) => v.toJson()).toList();
    }
    if (this.deviceLog2 != null) {
      data['device_log2'] = this.deviceLog2!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeviceLog {
  String? vehicleId;
  String? rto;
  String? datetime;
  String? geoId;
  String? geoName;
  String? geoType;
  String? geoStatus;
  String? acumulatedDistance;

  DeviceLog(
      {this.vehicleId,
      this.rto,
      this.datetime,
      this.geoId,
      this.geoName,
      this.geoType,
      this.geoStatus,
      this.acumulatedDistance});

  DeviceLog.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    rto = json['rto'];
    datetime = json['datetime'];
    geoId = json['geo_id'];
    geoName = json['geo_name'];
    geoType = json['geo_type'];
    geoStatus = json['geo_status'];
    acumulatedDistance = json['acumulated_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['rto'] = this.rto;
    data['datetime'] = this.datetime;
    data['geo_id'] = this.geoId;
    data['geo_name'] = this.geoName;
    data['geo_type'] = this.geoType;
    data['geo_status'] = this.geoStatus;
    data['acumulated_distance'] = this.acumulatedDistance;
    return data;
  }
}

class DeviceLog1 {
  String? vehicleId;
  String? rto;
  String? datetime;
  String? geoId;
  String? geoName;
  String? geoType;
  String? geoStatus;
  String? acumulatedDistance;

  DeviceLog1(
      {this.vehicleId,
      this.rto,
      this.datetime,
      this.geoId,
      this.geoName,
      this.geoType,
      this.geoStatus,
      this.acumulatedDistance});

  DeviceLog1.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    rto = json['rto'];
    datetime = json['datetime'];
    geoId = json['geo_id'];
    geoName = json['geo_name'];
    geoType = json['geo_type'];
    geoStatus = json['geo_status'];
    acumulatedDistance = json['acumulated_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['rto'] = this.rto;
    data['datetime'] = this.datetime;
    data['geo_id'] = this.geoId;
    data['geo_name'] = this.geoName;
    data['geo_type'] = this.geoType;
    data['geo_status'] = this.geoStatus;
    data['acumulated_distance'] = this.acumulatedDistance;
    return data;
  }
}

class DeviceLog2 {
  String? vehicleId;
  String? rto;
  String? datetime;
  String? geoId;
  String? geoName;
  String? geoType;
  String? geoStatus;
  String? acumulatedDistance;

  DeviceLog2(
      {this.vehicleId,
      this.rto,
      this.datetime,
      this.geoId,
      this.geoName,
      this.geoType,
      this.geoStatus,
      this.acumulatedDistance});

  DeviceLog2.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    rto = json['rto'];
    datetime = json['datetime'];
    geoId = json['geo_id'];
    geoName = json['geo_name'];
    geoType = json['geo_type'];
    geoStatus = json['geo_status'];
    acumulatedDistance = json['acumulated_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['rto'] = this.rto;
    data['datetime'] = this.datetime;
    data['geo_id'] = this.geoId;
    data['geo_name'] = this.geoName;
    data['geo_type'] = this.geoType;
    data['geo_status'] = this.geoStatus;
    data['acumulated_distance'] = this.acumulatedDistance;
    return data;
  }
}

class History {
  String? rto;
  String? inDatetime;
  String? outDatetime;
  String? geoName;
  String? duration;  // Changed to `num?` to accept both `int` and `String`
  num? distance;

  History({
    this.rto,
    this.inDatetime,
    this.outDatetime,
    this.geoName,
    this.duration,
    this.distance,
  });

  History.fromJson(Map<String, dynamic> json) {
    rto = json['rto'];
    inDatetime = json['in_datetime'];
    outDatetime = json['out_datetime'];
    geoName = json['geo_name'];
    duration = json['duration'];

    // Safely parse `duration` for both String and int types
    // if (json['duration'] is String) {
    //   // Check if the string is not empty and can be parsed
    //   duration = json['duration']!.isNotEmpty ? num.tryParse(json['duration']) : null;
    // } else if (json['duration'] is int) {
    //   duration = json['duration'];  // Directly assign if it's an int
    // } else {
    //   duration = null; // Handle cases where the field is missing or invalid
    // }

    // Safely parse `distance` for both String and num types
    if (json['distance'] is String) {
      distance = num.tryParse(json['distance']) ?? null;
    } else if (json['distance'] is num) {
      distance = json['distance'];
    } else {
      distance = null; // Handle cases where the field is missing or invalid
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rto'] = rto;
    data['in_datetime'] = inDatetime;
    data['out_datetime'] = outDatetime;
    data['geo_name'] = geoName;
    data['duration'] = duration;
    data['distance'] = distance;
    return data;
  }
}





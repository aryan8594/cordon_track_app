class SingleLiveVehicleModel {
  bool? status;
  String? message;
  List<Data>? data;
  User? user;
  String? pid;
  Params? params;

  SingleLiveVehicleModel(
      {this.status, this.message, this.data, this.user, this.pid, this.params});

  SingleLiveVehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pid = json['pid'];
    params =
        json['params'] != null ? new Params.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['pid'] = this.pid;
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? rto;
  String? vType;
  String? vCategory;
  String? location;
  String? latitude;
  String? longitude;
  String? direction;
  String? datetime;
  String? speed;
  String? gpsStatus;
  String? gsmSingnalStrength;
  String? acStatus;
  String? acSince;
  String? fuelValue;
  String? idleSince;
  String? stoppageSince;
  String? geoSince;
  String? ignitionStatus;
  String? powerStatus;
  String? panicStatus;
  String? caseOpenSwitchStatus;
  String? doorStatus;
  String? internalBatteryVoltage;
  String? externalBatteryVoltage;
  String? acumulatedDistance;
  String? distanceToday;
  String? geoStatus;
  String? remarks;
  String? vehicleGroup;
  String? citygeoStatus;
  String? citygeoSince;
  String? geoName;

  Data(
      {this.id,
      this.rto,
      this.vType,
      this.vCategory,
      this.location,
      this.latitude,
      this.longitude,
      this.direction,
      this.datetime,
      this.speed,
      this.gpsStatus,
      this.gsmSingnalStrength,
      this.acStatus,
      this.acSince,
      this.fuelValue,
      this.idleSince,
      this.stoppageSince,
      this.geoSince,
      this.ignitionStatus,
      this.powerStatus,
      this.panicStatus,
      this.caseOpenSwitchStatus,
      this.doorStatus,
      this.internalBatteryVoltage,
      this.externalBatteryVoltage,
      this.acumulatedDistance,
      this.distanceToday,
      this.geoStatus,
      this.remarks,
      this.vehicleGroup,
      this.citygeoStatus,
      this.citygeoSince,
      this.geoName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rto = json['rto'];
    vType = json['v_type'];
    vCategory = json['v_category'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    direction = json['direction'];
    datetime = json['datetime'];
    speed = json['speed'];
    gpsStatus = json['gps_status'];
    gsmSingnalStrength = json['gsm_singnal_strength'];
    acStatus = json['ac_status'];
    acSince = json['ac_since'];
    fuelValue = json['fuel_value'];
    idleSince = json['idle_since'];
    stoppageSince = json['stoppage_since'];
    geoSince = json['geo_since'];
    ignitionStatus = json['ignition_status'];
    powerStatus = json['power_status'];
    panicStatus = json['panic_status'];
    caseOpenSwitchStatus = json['case_open_switch_status'];
    doorStatus = json['door_status'];
    internalBatteryVoltage = json['internal_battery_voltage'];
    externalBatteryVoltage = json['external_battery_voltage'];
    acumulatedDistance = json['acumulated_distance'];
    distanceToday = json['distance_today'];
    geoStatus = json['geo_status'];
    remarks = json['remarks'];
    vehicleGroup = json['vehicle_group'];
    citygeoStatus = json['citygeo_status'];
    citygeoSince = json['citygeo_since'];
    geoName = json['geo_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rto'] = this.rto;
    data['v_type'] = this.vType;
    data['v_category'] = this.vCategory;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['direction'] = this.direction;
    data['datetime'] = this.datetime;
    data['speed'] = this.speed;
    data['gps_status'] = this.gpsStatus;
    data['gsm_singnal_strength'] = this.gsmSingnalStrength;
    data['ac_status'] = this.acStatus;
    data['ac_since'] = this.acSince;
    data['fuel_value'] = this.fuelValue;
    data['idle_since'] = this.idleSince;
    data['stoppage_since'] = this.stoppageSince;
    data['geo_since'] = this.geoSince;
    data['ignition_status'] = this.ignitionStatus;
    data['power_status'] = this.powerStatus;
    data['panic_status'] = this.panicStatus;
    data['case_open_switch_status'] = this.caseOpenSwitchStatus;
    data['door_status'] = this.doorStatus;
    data['internal_battery_voltage'] = this.internalBatteryVoltage;
    data['external_battery_voltage'] = this.externalBatteryVoltage;
    data['acumulated_distance'] = this.acumulatedDistance;
    data['distance_today'] = this.distanceToday;
    data['geo_status'] = this.geoStatus;
    data['remarks'] = this.remarks;
    data['vehicle_group'] = this.vehicleGroup;
    data['citygeo_status'] = this.citygeoStatus;
    data['citygeo_since'] = this.citygeoSince;
    data['geo_name'] = this.geoName;
    return data;
  }
}

class User {
  String? id;
  String? masterAccount;
  String? name;
  String? username;
  String? email;
  String? mobile;
  String? role;
  String? password;
  String? city;
  String? status;
  String? routematicsKey;
  String? reminderCheck;
  String? smsBalance;
  String? emailBalance;
  String? masterPassword;
  String? markerLabel;
  String? panicSound;
  String? startTime1;
  String? endTime1;
  String? startTime2;
  String? endTime2;
  String? startTime3;
  String? endTime3;
  String? startTime4;
  String? endTime4;
  String? startTime5;
  String? endTime5;
  String? mobileArray;
  String? emailArray;
  String? geoOnMap;
  String? createdby;
  String? modifiedby;
  String? createdon;
  String? modifiedon;
  String? token;

  User(
      {this.id,
      this.masterAccount,
      this.name,
      this.username,
      this.email,
      this.mobile,
      this.role,
      this.password,
      this.city,
      this.status,
      this.routematicsKey,
      this.reminderCheck,
      this.smsBalance,
      this.emailBalance,
      this.masterPassword,
      this.markerLabel,
      this.panicSound,
      this.startTime1,
      this.endTime1,
      this.startTime2,
      this.endTime2,
      this.startTime3,
      this.endTime3,
      this.startTime4,
      this.endTime4,
      this.startTime5,
      this.endTime5,
      this.mobileArray,
      this.emailArray,
      this.geoOnMap,
      this.createdby,
      this.modifiedby,
      this.createdon,
      this.modifiedon,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    masterAccount = json['master_account'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
    password = json['password'];
    city = json['city'];
    status = json['status'];
    routematicsKey = json['routematics_key'];
    reminderCheck = json['reminder_check'];
    smsBalance = json['sms_balance'];
    emailBalance = json['email_balance'];
    masterPassword = json['master_password'];
    markerLabel = json['marker_label'];
    panicSound = json['panic_sound'];
    startTime1 = json['start_time1'];
    endTime1 = json['end_time1'];
    startTime2 = json['start_time2'];
    endTime2 = json['end_time2'];
    startTime3 = json['start_time3'];
    endTime3 = json['end_time3'];
    startTime4 = json['start_time4'];
    endTime4 = json['end_time4'];
    startTime5 = json['start_time5'];
    endTime5 = json['end_time5'];
    mobileArray = json['mobile_array'];
    emailArray = json['email_array'];
    geoOnMap = json['geo_on_map'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    createdon = json['createdon'];
    modifiedon = json['modifiedon'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['master_account'] = this.masterAccount;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['password'] = this.password;
    data['city'] = this.city;
    data['status'] = this.status;
    data['routematics_key'] = this.routematicsKey;
    data['reminder_check'] = this.reminderCheck;
    data['sms_balance'] = this.smsBalance;
    data['email_balance'] = this.emailBalance;
    data['master_password'] = this.masterPassword;
    data['marker_label'] = this.markerLabel;
    data['panic_sound'] = this.panicSound;
    data['start_time1'] = this.startTime1;
    data['end_time1'] = this.endTime1;
    data['start_time2'] = this.startTime2;
    data['end_time2'] = this.endTime2;
    data['start_time3'] = this.startTime3;
    data['end_time3'] = this.endTime3;
    data['start_time4'] = this.startTime4;
    data['end_time4'] = this.endTime4;
    data['start_time5'] = this.startTime5;
    data['end_time5'] = this.endTime5;
    data['mobile_array'] = this.mobileArray;
    data['email_array'] = this.emailArray;
    data['geo_on_map'] = this.geoOnMap;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['createdon'] = this.createdon;
    data['modifiedon'] = this.modifiedon;
    data['token'] = this.token;
    return data;
  }
}

class Params {
  String? filter;
  String? value;
  String? userId;
  String? role;
  String? length;
  String? id;
  String? ids;
  String? group;
  String? trackUrl;
  String? filterType;
  String? filterValue;
  String? pageFor;
  String? masterAccount;

  Params(
      {this.filter,
      this.value,
      this.userId,
      this.role,
      this.length,
      this.id,
      this.ids,
      this.group,
      this.trackUrl,
      this.filterType,
      this.filterValue,
      this.pageFor,
      this.masterAccount});

  Params.fromJson(Map<String, dynamic> json) {
    filter = json['filter'];
    value = json['value'];
    userId = json['user_id'];
    role = json['role'];
    length = json['length'];
    id = json['id'];
    ids = json['ids'];
    group = json['group'];
    trackUrl = json['track_url'];
    filterType = json['filter_type'];
    filterValue = json['filter_value'];
    pageFor = json['page_for'];
    masterAccount = json['master_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filter'] = this.filter;
    data['value'] = this.value;
    data['user_id'] = this.userId;
    data['role'] = this.role;
    data['length'] = this.length;
    data['id'] = this.id;
    data['ids'] = this.ids;
    data['group'] = this.group;
    data['track_url'] = this.trackUrl;
    data['filter_type'] = this.filterType;
    data['filter_value'] = this.filterValue;
    data['page_for'] = this.pageFor;
    data['master_account'] = this.masterAccount;
    return data;
  }
}

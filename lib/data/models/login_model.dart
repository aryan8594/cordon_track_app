// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class LoginModel {
  bool? status;
  String? message;
  Data? data;
  String? token;

  LoginModel({this.status, this.message, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? username;
  String? email;
  String? mobile;
  String? role;
  String? city;
  String? status;
  String? smsBalance;
  String? emailBalance;
  String? panicSound;
  String? mobileArray;
  String? emailArray;
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
  String? geoOnMap;

  Data(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.mobile,
      this.role,
      this.city,
      this.status,
      this.smsBalance,
      this.emailBalance,
      this.panicSound,
      this.mobileArray,
      this.emailArray,
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
      this.geoOnMap});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
    city = json['city'];
    status = json['status'];
    smsBalance = json['sms_balance'];
    emailBalance = json['email_balance'];
    panicSound = json['panic_sound'];
    mobileArray = json['mobile_array'];
    emailArray = json['email_array'];
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
    geoOnMap = json['geo_on_map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['city'] = this.city;
    data['status'] = this.status;
    data['sms_balance'] = this.smsBalance;
    data['email_balance'] = this.emailBalance;
    data['panic_sound'] = this.panicSound;
    data['mobile_array'] = this.mobileArray;
    data['email_array'] = this.emailArray;
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
    data['geo_on_map'] = this.geoOnMap;
    return data;
  }
}

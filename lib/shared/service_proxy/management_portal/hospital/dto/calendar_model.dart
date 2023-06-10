class CalendarModel {
  DateTime dateTime;
  List<Doctors> doctors;
  int serviceId;
  bool isCash;

  CalendarModel({this.dateTime, this.doctors, this.serviceId, this.isCash});

  CalendarModel.fromJson(Map<String, dynamic> json) {
    dateTime =
        json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null;
    if (json['doctors'] != null) {
      doctors = new List<Doctors>();
      json['doctors'].forEach((v) {
        doctors.add(new Doctors.fromJson(v));
      });
    }
    serviceId = json['service_id'];
    isCash = json['is_cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime?.toIso8601String();
    if (this.doctors != null) {
      data['doctors'] = this.doctors.map((v) => v.toJson()).toList();
    }
    data['service_id'] = this.serviceId;
    data['is_cash'] = this.isCash;
    return data;
  }
}

class Doctors {
  int id;
  String name;
  String avatar;
  List<WorkingTime> workingTime;
  int clinicId;

  Doctors({this.id, this.name, this.avatar, this.workingTime, this.clinicId});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    if (json['working_Time'] != null) {
      workingTime = new List<WorkingTime>();
      json['working_Time'].forEach((v) {
        workingTime.add(new WorkingTime.fromJson(v));
      });
    }
    clinicId = json['clinic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    if (this.workingTime != null) {
      data['working_Time'] = this.workingTime.map((v) => v.toJson()).toList();
    }
    data['clinic_id'] = this.clinicId;
    return data;
  }
}

class WorkingTime {
  String hour;
  bool isActive;

  WorkingTime({this.hour, this.isActive});

  WorkingTime.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['is_active'] = this.isActive;
    return data;
  }
}

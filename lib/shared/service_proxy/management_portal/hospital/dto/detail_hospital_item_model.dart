class DetailHospitalModel {
  int id;
  int code;
  String name;
  String email;
  String phone;
  String address;
  String department;
  int totalRateGood;
  int totalRateBad;
  double totalRates;
  int totalPoint;
  int totalLike;
  List<RateInfo> rateInfo;
  String avatar;
  String latLong;
  int type;
  ClientInfo clientInfo;
  List<Services> services;
  bool isBooking;
  String city;
  bool isLike;
  String isBookingString;
  int star;
  String comment;

  DetailHospitalModel(
      {this.id,
      this.code,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.department,
      this.totalRateGood,
      this.totalRateBad,
      this.totalRates,
      this.totalPoint,
      this.totalLike,
      this.rateInfo,
      this.avatar,
      this.latLong,
      this.type,
      this.clientInfo,
      this.services,
      this.isBooking,
      this.city,
      this.isLike,
      this.isBookingString,
      this.star,
      this.comment});

  DetailHospitalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    department = json['department'];
    totalRateGood = json['total_Rate_Good'];
    totalRateBad = json['total_Rate_Bad'];
    totalRates = json['totalRates'];
    totalPoint = json['total_Point'];
    totalLike = json['totalLike'];
    if (json['rateInfo'] != null) {
      rateInfo = new List<RateInfo>();
      json['rateInfo'].forEach((v) {
        rateInfo.add(new RateInfo.fromJson(v));
      });
    }
    avatar = json['avatar'];
    latLong = json['lat_Long'];
    type = json['type'];
    clientInfo = json['clientInfo'] != null
        ? new ClientInfo.fromJson(json['clientInfo'])
        : null;
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    isBooking = json['is_booking'];
    city = json['city'];
    isLike = json['is_like'];
    isBookingString = json['isBooking'];
    star = json['star'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['department'] = this.department;
    data['total_Rate_Good'] = this.totalRateGood;
    data['total_Rate_Bad'] = this.totalRateBad;
    data['totalRates'] = this.totalRates;
    data['total_Point'] = this.totalPoint;
    data['totalLike'] = this.totalLike;
    if (this.rateInfo != null) {
      data['rateInfo'] = this.rateInfo.map((v) => v.toJson()).toList();
    }
    data['avatar'] = this.avatar;
    data['lat_Long'] = this.latLong;
    data['type'] = this.type;
    if (this.clientInfo != null) {
      data['clientInfo'] = this.clientInfo.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    data['is_booking'] = this.isBooking;
    data['city'] = this.city;
    data['is_like'] = this.isLike;
    data['isBooking'] = this.isBookingString;
    data['star'] = this.star;
    data['comment'] = this.comment;
    return data;
  }
}

class RateInfo {
  String patientName;
  String avatar;
  String comment;
  String createdAt;
  int rateNo;
  int clinicId;
  int id;

  RateInfo(
      {this.patientName,
      this.avatar,
      this.comment,
      this.createdAt,
      this.rateNo,
      this.clinicId,
      this.id});

  RateInfo.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    avatar = json['avatar'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    rateNo = json['rateNo'];
    clinicId = json['clinic_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientName'] = this.patientName;
    data['avatar'] = this.avatar;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['rateNo'] = this.rateNo;
    data['clinic_id'] = this.clinicId;
    data['id'] = this.id;
    return data;
  }
}

class ClientInfo {
  String title;
  String home;
  String workingTime;
  String shortDescription;
  String longDescription;
  String background;
  bool isChat;
  bool isVideo;
  String hotLine;
  List<String> imgList;
  int limitTime;
  int timeUsed;
  int totalTime;

  ClientInfo(
      {this.title,
      this.home,
      this.workingTime,
      this.shortDescription,
      this.longDescription,
      this.background,
      this.isChat,
      this.isVideo,
      this.hotLine,
      this.imgList,
      this.limitTime,
      this.timeUsed,
      this.totalTime});

  ClientInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    home = json['home'];
    workingTime = json['working_Time'];
    shortDescription = json['short_Description'];
    longDescription = json['long_description'];
    background = json['background'];
    isChat = json['is_chat'];
    isVideo = json['is_video'];
    hotLine = json['hot_line'];
    imgList = json['img_list'].cast<String>();
    limitTime = json['limit_time'];
    timeUsed = json['time_used'];
    totalTime = json['total_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['home'] = this.home;
    data['working_Time'] = this.workingTime;
    data['short_Description'] = this.shortDescription;
    data['long_description'] = this.longDescription;
    data['background'] = this.background;
    data['is_chat'] = this.isChat;
    data['is_video'] = this.isVideo;
    data['hot_line'] = this.hotLine;
    data['img_list'] = this.imgList;
    data['limit_time'] = this.limitTime;
    data['time_used'] = this.timeUsed;
    data['total_time'] = this.totalTime;
    return data;
  }
}

class Services {
  int id;
  String name;
  String shortDescription;
  String longDescription;
  String technialDescription;
  String doiTuong;
  String thiNghiem;
  String luaTuoi;
  String hangMuc;
  double price;
  String whyTitle;
  bool isActive;
  int clinicId;
  List<WhyInfos> whyInfos;
  List<Process> process;
  String note;
  List<GetItems> getItems;
  String thumb;
  String imgList;
  bool isCash;

  Services(
      {this.id,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.technialDescription,
      this.doiTuong,
      this.thiNghiem,
      this.luaTuoi,
      this.hangMuc,
      this.price,
      this.whyTitle,
      this.isActive,
      this.clinicId,
      this.whyInfos,
      this.process,
      this.note,
      this.getItems,
      this.thumb,
      this.imgList,
      this.isCash});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    technialDescription = json['technial_description'];
    doiTuong = json['doi_tuong'];
    thiNghiem = json['thi_nghiem'];
    luaTuoi = json['lua_tuoi'];
    hangMuc = json['hang_muc'];
    price = json['price'];
    whyTitle = json['why_title'];
    isActive = json['is_active'];
    clinicId = json['clinic_id'];
    if (json['whyInfos'] != null) {
      whyInfos = new List<WhyInfos>();
      json['whyInfos'].forEach((v) {
        whyInfos.add(new WhyInfos.fromJson(v));
      });
    }
    if (json['process'] != null) {
      process = new List<Process>();
      json['process'].forEach((v) {
        process.add(new Process.fromJson(v));
      });
    }
    note = json['note'];
    if (json['getItems'] != null) {
      getItems = new List<GetItems>();
      json['getItems'].forEach((v) {
        getItems.add(new GetItems.fromJson(v));
      });
    }
    thumb = json['thumb'];
    imgList = json['img_list'];
    isCash = json['is_cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['long_description'] = this.longDescription;
    data['technial_description'] = this.technialDescription;
    data['doi_tuong'] = this.doiTuong;
    data['thi_nghiem'] = this.thiNghiem;
    data['lua_tuoi'] = this.luaTuoi;
    data['hang_muc'] = this.hangMuc;
    data['price'] = this.price;
    data['why_title'] = this.whyTitle;
    data['is_active'] = this.isActive;
    data['clinic_id'] = this.clinicId;
    if (this.whyInfos != null) {
      data['whyInfos'] = this.whyInfos.map((v) => v.toJson()).toList();
    }
    if (this.process != null) {
      data['process'] = this.process.map((v) => v.toJson()).toList();
    }
    data['note'] = this.note;
    if (this.getItems != null) {
      data['getItems'] = this.getItems.map((v) => v.toJson()).toList();
    }
    data['thumb'] = this.thumb;
    data['img_list'] = this.imgList;
    data['is_cash'] = this.isCash;
    return data;
  }
}

class Process {
  int id;
  String title;
  String content;
  String avatar;
  int service;
  bool isFree;

  Process(
      {this.id,
      this.title,
      this.content,
      this.avatar,
      this.service,
      this.isFree});

  Process.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    avatar = json['avatar'];
    service = json['service'];
    isFree = json['is_free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['avatar'] = this.avatar;
    data['service'] = this.service;
    data['is_free'] = this.isFree;
    return data;
  }
}

class WhyInfos {
  int id;
  String title;
  String content;
  String avatar;
  int service;
  bool isFree;

  WhyInfos(
      {this.id,
      this.title,
      this.content,
      this.avatar,
      this.service,
      this.isFree});

  WhyInfos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    avatar = json['avatar'];
    service = json['service'];
    isFree = json['is_free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['avatar'] = this.avatar;
    data['service'] = this.service;
    data['is_free'] = this.isFree;
    return data;
  }
}

class GetItems {
  String name;
  List<String> items;

  GetItems({this.name, this.items});

  GetItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    items = json['items'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['items'] = this.items;
    return data;
  }
}

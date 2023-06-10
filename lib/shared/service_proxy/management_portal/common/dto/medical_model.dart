class MedicalModel {
  int id;
  String name;
  String shortDescription;
  String longDescription;
  String technialDescription;
  bool isActive;
  int clinicId;
  String thumb;
  List<String> imgList;
  int rateNo;
  bool isChat;
  bool isVideo;
  Null hotLine;
  int limitTime;
  int timeUsed;
  int totalTime;
  double price;
  bool isCash;

  MedicalModel(
      {this.id,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.technialDescription,
      this.isActive,
      this.clinicId,
      this.thumb,
      this.imgList,
      this.rateNo,
      this.isChat,
      this.isVideo,
      this.hotLine,
      this.limitTime,
      this.timeUsed,
      this.totalTime,
      this.price,
      this.isCash});

  MedicalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    technialDescription = json['technial_description'];
    isActive = json['is_active'];
    clinicId = json['clinic_id'];
    thumb = json['thumb'];
    imgList = json['img_list'].cast<String>();
    rateNo = json['rate_no'];
    isChat = json['is_chat'];
    isVideo = json['is_video'];
    hotLine = json['hot_line'];
    limitTime = json['limit_time'];
    timeUsed = json['time_used'];
    totalTime = json['total_time'];
    price = json['price'];
    isCash = json['is_cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['long_description'] = this.longDescription;
    data['technial_description'] = this.technialDescription;
    data['is_active'] = this.isActive;
    data['clinic_id'] = this.clinicId;
    data['thumb'] = this.thumb;
    data['img_list'] = this.imgList;
    data['rate_no'] = this.rateNo;
    data['is_chat'] = this.isChat;
    data['is_video'] = this.isVideo;
    data['hot_line'] = this.hotLine;
    data['limit_time'] = this.limitTime;
    data['time_used'] = this.timeUsed;
    data['total_time'] = this.totalTime;
    data['price'] = this.price;
    data['is_cash'] = this.isCash;
    return data;
  }
}
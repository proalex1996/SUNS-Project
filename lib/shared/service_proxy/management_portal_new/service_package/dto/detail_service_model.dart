class DetailServiceModel {
  DetailServiceModel({
    this.useStaff,
    this.useBookingTime,
    this.cashAccepted,
    this.paymentMethod,
    this.paymentMethods,
    this.note,
    this.whyInfos,
    this.processes,
    this.companyType,
    this.companyId,
    this.companyName,
    this.companyAddress,
    this.id,
    this.name,
    this.image,
    this.description,
    this.gender,
    this.test,
    this.exam,
    this.fromAge,
    this.toAge,
    this.price,
  });

  bool useStaff;
  bool useBookingTime;
  bool cashAccepted;
  int paymentMethod;
  List<PaymentMethod> paymentMethods;
  String note;
  List<Process> whyInfos;
  List<Process> processes;
  int companyType;
  String companyId;
  String companyName;
  String companyAddress;
  String id;
  String name;
  String image;
  String description;
  dynamic gender;
  int test;
  int exam;
  dynamic fromAge;
  dynamic toAge;
  int price;

  factory DetailServiceModel.fromJson(Map<String, dynamic> json) =>
      DetailServiceModel(
        useStaff: json["useStaff"],
        useBookingTime: json["useBookingTime"],
        cashAccepted: json["cashAccepted"],
        paymentMethod: json["paymentMethod"],
        paymentMethods: List<PaymentMethod>.from(
            json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
        note: json["note"],
        whyInfos: List<Process>.from(
            json["whyInfos"].map((x) => Process.fromJson(x))),
        processes: List<Process>.from(
            json["processes"].map((x) => Process.fromJson(x))),
        companyType: json["companyType"],
        companyId: json["companyId"],
        companyName: json["companyName"],
        companyAddress: json["companyAddress"],
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        gender: json["gender"],
        test: json["test"],
        exam: json["exam"],
        fromAge: json["fromAge"],
        toAge: json["toAge"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "useStaff": useStaff,
        "useBookingTime": useBookingTime,
        "cashAccepted": cashAccepted,
        "paymentMethod": paymentMethod,
        "paymentMethods":
            List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "note": note,
        "whyInfos": List<dynamic>.from(whyInfos.map((x) => x.toJson())),
        "processes": List<dynamic>.from(processes.map((x) => x.toJson())),
        "companyType": companyType,
        "companyId": companyId,
        "companyName": companyName,
        "companyAddress": companyAddress,
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "gender": gender,
        "test": test,
        "exam": exam,
        "fromAge": fromAge,
        "toAge": toAge,
        "price": price,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Process {
  Process({
    this.name,
    this.description,
    this.image,
    this.isFree,
  });

  String name;
  String description;
  dynamic image;
  bool isFree;

  factory Process.fromJson(Map<String, dynamic> json) => Process(
        name: json["name"],
        description: json["description"],
        image: json["image"],
        isFree: json["isFree"] == null ? null : json["isFree"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": image,
        "isFree": isFree == null ? null : isFree,
      };
}

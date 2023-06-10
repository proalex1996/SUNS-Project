class OrderModelNew {
  String id;
  String code;
  int amount;
  String paidTime;
  String transactionId;
  String note;
  bool isPaid;
  String createdTime;
  int paymentMethod;
  List<Items> items;

  OrderModelNew(
      {this.id,
      this.code,
      this.amount,
      this.paidTime,
      this.transactionId,
      this.note,
      this.isPaid,
      this.createdTime,
      this.paymentMethod,
      this.items});

  OrderModelNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    paidTime = json['paidTime'];
    transactionId = json['transactionId'];
    note = json['note'];
    isPaid = json['isPaid'];
    createdTime = json['createdTime'];
    paymentMethod = json['paymentMethod'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['paidTime'] = this.paidTime;
    data['transactionId'] = this.transactionId;
    data['note'] = this.note;
    data['isPaid'] = this.isPaid;
    data['createdTime'] = this.createdTime;
    data['paymentMethod'] = this.paymentMethod;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  Items({
    this.name,
    this.image,
    this.description,
    this.price,
    this.type,
    this.gender,
    this.test,
    this.exam,
    this.fromAge,
    this.toAge,
    this.unitPrice,
    this.quantity,
    this.medicineId,
  });

  String name;
  String image;
  String description;
  int price;
  String type;
  int gender;
  int test;
  int exam;
  int fromAge;
  int toAge;
  int unitPrice;
  int quantity;
  String medicineId;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        name: json["name"],
        image: json["image"],
        description: json["description"],
        price: json["price"],
        type: json["type"],
        gender: json["gender"],
        test: json["test"],
        exam: json["exam"],
        fromAge: json["fromAge"],
        toAge: json["toAge"],
        unitPrice: json["unitPrice"],
        quantity: json["quantity"],
        medicineId: json["medicineId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description": description,
        "price": price,
        "type": type,
        "gender": gender,
        "test": test,
        "exam": exam,
        "fromAge": fromAge,
        "toAge": toAge,
        "unitPrice": unitPrice,
        "quantity": quantity,
        "medicineId": medicineId,
      };
}

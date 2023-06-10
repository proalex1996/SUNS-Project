class DetailOrderModel {
  List<Items> items;
  String id;
  String code;
  int amount;
  String paidTime;
  String transactionId;
  String note;
  bool isPaid;
  String createdTime;
  int paymentMethod;

  DetailOrderModel(
      {this.items,
      this.id,
      this.code,
      this.amount,
      this.paidTime,
      this.transactionId,
      this.note,
      this.isPaid,
      this.createdTime,
      this.paymentMethod});

  DetailOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    paidTime = json['paidTime'];
    transactionId = json['transactionId'];
    note = json['note'];
    isPaid = json['isPaid'];
    createdTime = json['createdTime'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['paidTime'] = this.paidTime;
    data['transactionId'] = this.transactionId;
    data['note'] = this.note;
    data['isPaid'] = this.isPaid;
    data['createdTime'] = this.createdTime;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}

class Items {
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
  String medicineName;

  Items(
      {this.name,
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
      this.medicineName});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    type = json['type'];
    gender = json['gender'];
    test = json['test'];
    exam = json['exam'];
    fromAge = json['fromAge'];
    toAge = json['toAge'];
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    medicineId = json['medicineId'];
    medicineName = json['medicineName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['price'] = this.price;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['test'] = this.test;
    data['exam'] = this.exam;
    data['fromAge'] = this.fromAge;
    data['toAge'] = this.toAge;
    data['unitPrice'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['medicineId'] = this.medicineId;
    data['medicineName'] = this.medicineName;
    return data;
  }
}

class PlaceOrdersModel {
  List<Medicines> medicines;
  String shippingAddressId;

  PlaceOrdersModel({this.medicines, this.shippingAddressId});

  PlaceOrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['medicines'] != null) {
      medicines = new List<Medicines>();
      json['medicines'].forEach((v) {
        medicines.add(new Medicines.fromJson(v));
      });
    }
    shippingAddressId = json['shippingAddressId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicines != null) {
      data['medicines'] = this.medicines.map((v) => v.toJson()).toList();
    }
    data['shippingAddressId'] = this.shippingAddressId;
    return data;
  }
}

class Medicines {
  String medicineId;
  int quantity;

  Medicines({this.medicineId, this.quantity});

  Medicines.fromJson(Map<String, dynamic> json) {
    medicineId = json['medicineId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineId'] = this.medicineId;
    data['quantity'] = this.quantity;
    return data;
  }
}

class MedicineModel {
  String id;
  String name;
  String image;
  int price;
  String strengths;

  MedicineModel({this.id, this.name, this.image, this.price, this.strengths});

  MedicineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    strengths = json['strengths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['strengths'] = this.strengths;
    return data;
  }
}

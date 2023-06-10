class DetailMedicineModel {
  String description;
  double rating;
  String code;
  String id;
  String name;
  String image;
  int price;
  String strengths;

  DetailMedicineModel(
      {this.description,
      this.rating,
      this.code,
      this.id,
      this.name,
      this.image,
      this.price,
      this.strengths});

  DetailMedicineModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    rating = json['rating'];
    code = json['code'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    strengths = json['strengths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['code'] = this.code;
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['strengths'] = this.strengths;
    return data;
  }
}

class EquipmentModel {
  String id;
  String name;
  String description;
  String specifications;
  String image;
  String images;
  int rating;
  int price;
  int discountPrice;

  EquipmentModel(
      {this.id,
      this.name,
      this.description,
      this.specifications,
      this.image,
      this.images,
      this.rating,
      this.price,
      this.discountPrice});

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    specifications = json['specifications'];
    image = json['image'];
    images = json['images'];
    rating = json['rating'];
    price = json['price'];
    discountPrice = json['discountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['specifications'] = this.specifications;
    data['image'] = this.image;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['discountPrice'] = this.discountPrice;
    return data;
  }
}

class PackageModel {
  int id;
  String name;
  String image;
  String description;
  int gender;
  int test;
  int exam;
  int fromAge;
  int toAge;
  int price;
  int paymentMethod;

  PackageModel(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.gender,
      this.test,
      this.exam,
      this.fromAge,
      this.toAge,
      this.price,
      this.paymentMethod});

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    gender = json['gender'];
    test = json['test'];
    exam = json['exam'];
    fromAge = json['fromAge'];
    toAge = json['toAge'];
    price = json['price'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['gender'] = this.gender;
    data['test'] = this.test;
    data['exam'] = this.exam;
    data['fromAge'] = this.fromAge;
    data['toAge'] = this.toAge;
    data['price'] = this.price;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}

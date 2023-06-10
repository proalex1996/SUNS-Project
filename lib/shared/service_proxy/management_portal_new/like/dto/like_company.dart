class LikeCompanyModel {
  String id;
  String name;
  String image;
  String address;
  bool isSpecialized;
  String specialized;
  double rating;
  int type;
  int totalLike;

  LikeCompanyModel(
      {this.id,
      this.name,
      this.image,
      this.address,
      this.isSpecialized,
      this.specialized,
      this.rating,
      this.type,
      this.totalLike});

  LikeCompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    address = json['address'];
    isSpecialized = json['isSpecialized'];
    specialized = json['specialized'];
    rating = json['rating'];
    type = json['type'];
    totalLike = json['totalLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['address'] = this.address;
    data['isSpecialized'] = this.isSpecialized;
    data['specialized'] = this.specialized;
    data['rating'] = this.rating;
    data['type'] = this.type;
    data['totalLike'] = this.totalLike;
    return data;
  }
}
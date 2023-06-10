class LikeNewsModel {
  String id;
  String name;
  String image;
  String shortDescription;
  String description;
  int totalLike;
  int totalShare;
  int totalView;
  int categoryId;
  String categoryName;
  String lastUpdated;

  LikeNewsModel(
      {this.id,
      this.name,
      this.image,
      this.shortDescription,
      this.description,
      this.totalLike,
      this.totalShare,
      this.totalView,
      this.categoryId,
      this.categoryName,
      this.lastUpdated});

  LikeNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    shortDescription = json['shortDescription'];
    description = json['description'];
    totalLike = json['totalLike'];
    totalShare = json['totalShare'];
    totalView = json['totalView'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['shortDescription'] = this.shortDescription;
    data['description'] = this.description;
    data['totalLike'] = this.totalLike;
    data['totalShare'] = this.totalShare;
    data['totalView'] = this.totalView;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['lastUpdated'] = this.lastUpdated;
    return data;
  }
}
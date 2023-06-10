class InputPostModel {
  String name;
  String shortDescription;
  String imageFile;
  String description;

  InputPostModel(
      {this.name, this.shortDescription, this.imageFile, this.description});

  InputPostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortDescription = json['shortDescription'];
    imageFile = json['imageFile'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['imageFile'] = this.imageFile;
    data['description'] = this.description;
    return data;
  }
}

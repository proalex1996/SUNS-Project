class StaffModel {
  String image;
  String id;
  String name;

  StaffModel({this.image, this.id, this.name});

  StaffModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

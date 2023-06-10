class ProvinceModel {
  String id;
  String name;
  String area;

  ProvinceModel({this.id, this.name, this.area});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['area'] = this.area;

    return data;
  }
}

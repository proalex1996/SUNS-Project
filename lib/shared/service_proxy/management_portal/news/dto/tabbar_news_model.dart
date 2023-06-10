class MenuNewsModel {
  int id;
  String name;
  int order;

  MenuNewsModel({this.id, this.name, this.order});

  MenuNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    return data;
  }
}

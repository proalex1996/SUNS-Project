class UserRatingModel {
  String id;
  String fullName;
  String avatar;

  UserRatingModel({this.id, this.fullName, this.avatar});

  UserRatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    return data;
  }
}

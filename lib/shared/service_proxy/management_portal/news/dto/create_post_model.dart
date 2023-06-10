class CreatePostModel {
  int menuId;
  String title;
  String content;
  String avatar;

  CreatePostModel({this.menuId, this.title, this.content, this.avatar});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    title = json['title'];
    content = json['content'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['avatar'] = this.avatar;
    return data;
  }
}

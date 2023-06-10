class NewsModel {
  int id;
  String title;
  String shortDescription;
  String longDescription;
  String thumbnail;
  Null imgList;
  String createdAt;
  String lastUpdated;
  int totalView;
  int totalLike;
  int menuId;
  List<Null> comment;
  int totalShare;
  int totalComment;
  bool isRadio;
  String resource;
  String menuName;
  bool isLike;
  String resourceview;
  String userName;
  Null userLike;

  NewsModel(
      {this.id,
      this.title,
      this.shortDescription,
      this.longDescription,
      this.thumbnail,
      this.imgList,
      this.createdAt,
      this.lastUpdated,
      this.totalView,
      this.totalLike,
      this.menuId,
      this.comment,
      this.totalShare,
      this.totalComment,
      this.isRadio,
      this.resource,
      this.menuName,
      this.isLike,
      this.resourceview,
      this.userName,
      this.userLike});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    thumbnail = json['thumbnail'];
    imgList = json['img_list'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    totalView = json['total_view'];
    totalLike = json['total_like'];
    menuId = json['menu_id'];
    if (json['comment'] != null) {
      comment = new List<Null>();
    }
    totalShare = json['total_share'];
    totalComment = json['total_comment'];
    isRadio = json['is_radio'];
    resource = json['resource'];
    menuName = json['menu_name'];
    isLike = json['is_like'];
    resourceview = json['resourceview'];
    userName = json['userName'];
    userLike = json['userLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['long_description'] = this.longDescription;
    data['thumbnail'] = this.thumbnail;
    data['img_list'] = this.imgList;
    data['created_at'] = this.createdAt;
    data['last_updated'] = this.lastUpdated;
    data['total_view'] = this.totalView;
    data['total_like'] = this.totalLike;
    data['menu_id'] = this.menuId;
    if (this.comment != null) {
      data['comment'] = this.comment.map((v) => v).toList();
    }
    data['total_share'] = this.totalShare;
    data['total_comment'] = this.totalComment;
    data['is_radio'] = this.isRadio;
    data['resource'] = this.resource;
    data['menu_name'] = this.menuName;
    data['is_like'] = this.isLike;
    data['resourceview'] = this.resourceview;
    data['userName'] = this.userName;
    data['userLike'] = this.userLike;
    return data;
  }
}

class AllNewsModel {
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

  AllNewsModel(
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

  AllNewsModel.fromJson(Map<String, dynamic> json) {
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

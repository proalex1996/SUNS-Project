class InputRatingCommentModel {
  int rating;
  String comment;

  InputRatingCommentModel({this.rating, this.comment});

  InputRatingCommentModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}
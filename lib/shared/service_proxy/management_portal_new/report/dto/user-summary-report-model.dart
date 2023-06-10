class UserSummaryReportModel {
  UserSummaryReportModel({
    this.totalLike,
    this.totalShare,
    this.totalPost,
    this.totalPoint,
    this.totalComment,
  });

  int totalLike;
  int totalShare;
  int totalPost;
  int totalPoint;
  int totalComment;

  factory UserSummaryReportModel.fromJson(Map<String, dynamic> json) =>
      UserSummaryReportModel(
        totalLike: json["totalLike"],
        totalShare: json["totalShare"],
        totalPost: json["totalPost"],
        totalPoint: json["totalPoint"],
        totalComment: json["totalComment"],
      );

  Map<String, dynamic> toJson() => {
        "totalLike": totalLike,
        "totalShare": totalShare,
        "totalPost": totalPost,
        "totalPoint": totalPoint,
        "totalComment": totalComment,
      };
}

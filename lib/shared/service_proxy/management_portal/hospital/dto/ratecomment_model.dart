class RateCommentModel {
  String userName;
  String comment;
  int rateNo;
  int clinicId;

  RateCommentModel({this.userName, this.comment, this.rateNo, this.clinicId});

  RateCommentModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    comment = json['comment'];
    rateNo = json['rate_No'];
    clinicId = json['clinic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['comment'] = this.comment;
    data['rate_No'] = this.rateNo;
    data['clinic_id'] = this.clinicId;
    return data;
  }
}

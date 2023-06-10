class ForgotPasswordModel {
  ForgotPasswordModel({
    this.phoneNumber,
    this.password,
    this.sessionInfo,
    this.token,
  });

  String phoneNumber;
  String password;
  String sessionInfo;
  String token;

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        sessionInfo: json["sessionInfo"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "password": password,
        "sessionInfo": sessionInfo,
        "token": token,
      };
}

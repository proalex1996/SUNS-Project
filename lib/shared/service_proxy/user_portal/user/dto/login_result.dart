class LoginResult {
  String accessToken;
  String refreshToken;
  int expiresIn;
  String tokenType;
  String scope;

  LoginResult({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.scope,
  });

  LoginResult.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    return data;
  }
}

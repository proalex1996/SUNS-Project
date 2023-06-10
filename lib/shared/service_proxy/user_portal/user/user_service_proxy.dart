import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/change_password_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/check_exist_phone_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/create_contact_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/create_devicetoken_input.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/forgot_password_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/login_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/register_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/register_result.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/sms_otp_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/upload_avatar_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_rating_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_update_model.dart';
import 'dto/login_result.dart';

class UserServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  UserServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/Users",
      appAuthService: appAuthService,
    );
  }

  Future<LoginResult> login(LoginModel model) async {
    var result = await client.post("/Login", jsonEncode(model.toJson()));
    var loginResult = LoginResult.fromJson(result);

    return loginResult;
  }

  Future<RegisterResult> register(RegisterModel model) async {
    var d = Map<String, dynamic>();
    d["phoneNumber"] = model.phoneNumber;
    d["password"] = model.password;
    d["deviceToken"] = model.deviceToken;
    d["companyId"] = model.companyId;
    d["applicationId"] = model.applicationId;
    print(jsonEncode(d));
    var result = await client.post("/register", jsonEncode(d));
    var registerResult = RegisterResult.fromJson(result);

    return registerResult;
  }

  Future<List<ContactModel>> getContacts() async {
    var res = await client.get("/get-contacts");
    var data = new List<ContactModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new ContactModel.fromJson(v));
      });
    }

    return data;
  }

    Future<bool> deleteContact(int id) async {
    var res = await client.delete("/delete-contact/$id");
    return res;
  }

  Future<List<ContactModel>> getSearchContacts(String keyword) async {
    var keyWord = keyword == null ? "" : "name=$keyword";
    var res = await client.get("/get-contacts?$keyWord");
    var data = new List<ContactModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new ContactModel.fromJson(v));
      });
    }

    return data;
  }

  Future<UserModel> getUserInfo() async {
    var res = await client.get("/get-user-info");
    var data = UserModel.fromJson(res);

    return data;
  }

  Future<String> getUsagePolicy() async {
    String res = await client.get("/get-policy");

    return res;
  }

  Future<UserModel> updateUser(UserUpdateModel userUpdateModel) async {
    print(jsonEncode(userUpdateModel.toJson()));
    var result = await client.put(
        "/update-user-info", jsonEncode(userUpdateModel.toJson()));

    var userModel = UserModel.fromJson(result);

    return userModel;
  }

  Future<int> createContact(CreateContactModel createCotactModel) async {
    print(jsonEncode(createCotactModel.toJson()));
    var res = await client.post(
      "/create-contact",
      jsonEncode(
        createCotactModel.toJson(),
      ),
    );
    return res;
  }

  Future<int> updateContact(int contactId, ContactModel updateContact) async {
    var res = await client.put(
      "/update-contact?contactId=$contactId",
      jsonEncode(
        updateContact.toJson(),
      ),
    );
    return res;
  }

  Future changePassword(ChangePasswordModel changePasswordModel) async {
    await client.put(
      "/change-password",
      jsonEncode(
        changePasswordModel.toJson(),
      ),
    );
  }

  Future<ContactModel> getContact() async {
    var res = await client.get("/get-contacts");
    var data = new ContactModel.fromJson(res);

    return data;
  }

  Future<bool> forgotPass(ForgotPasswordModel forgotPasswordModel) async {
    var res = await client.post(
        "/forgot-password", jsonEncode(forgotPasswordModel.toJson()));
    return res;
  }

  Future sendSMSOTP(SendSMSOTPInput model) async {
    var res = await client.post(
        "/send-smsotp", jsonEncode(model.toJson()));
    return res;
  }

  Future<String> verifySMSOTP(VerifySMSOTPInput model) async {
    var res = await client.post(
        "/verify-smsotp", jsonEncode(model.toJson()));
    return res;
  }

  Future uploadAvatar(UploadAvatarModel uploadAvatarModel) async {
    print(jsonEncode(uploadAvatarModel.toJson()));
    await client.post("/UploadAvatar", jsonEncode(uploadAvatarModel.toJson()));
  }

  Future checkExistPhone(CheckExistPhoneModel phoneNumber) async {
    await client.post("/check-exist-phone", jsonEncode(phoneNumber.toJson()));
  }

  Future<List<UserRatingModel>> getUserRating(List<int> userIds) async {
    var res = await client.post("/get-user-infos", jsonEncode(userIds));
    var data = new List<UserRatingModel>();
    if (res != null) {
      res.forEach((v) {
        data.add(new UserRatingModel.fromJson(v));
      });
    }
    return data;
  }

  Future updateDeviceToken(CreateDeviceTokenInput model) async {
    await client.put("/update-device-token", jsonEncode(model.toJson()));
  }
}

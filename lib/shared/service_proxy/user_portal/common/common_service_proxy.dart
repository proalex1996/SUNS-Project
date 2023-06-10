import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/district_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/ward_model.dart';

class CommonServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  CommonServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/Common",
      appAuthService: appAuthService,
    );
  }

  Future<List<ProvinceModel>> getAllCities() async {
    var res = await client.get("/get-all-cities");
    var data = new List<ProvinceModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new ProvinceModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<DistrictModel>> getDistricts(String provinceId) async {
    var res = await client.get("/get-all-districts/$provinceId");
    var data = List<DistrictModel>();
    if (res != null) {
      res.forEach((v) {
        data.add(DistrictModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<WardModel>> getWards(String districtId) async {
    var res = await client.get("/get-all-wards/$districtId");
    var data = List<WardModel>();
    if (res != null) {
      res.forEach((v) {
        data.add(WardModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<RelationshipModel>> getAllRelationship() async {
    var res = await client.get("/get-relationship");
    var data = new List<RelationshipModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new RelationshipModel.fromJson(v));
      });
    }

    return data;
  }

  Future<RelationshipModel> getRelationship() async {
    var res = await client.get("/get-relationship");
    var data = RelationshipModel.fromJson(res);

    return data;
  }

  Future<List<GenderModel>> getAllGender() async {
    var res = await client.get("/get-gender");
    var data = new List<GenderModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new GenderModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<DistrictModel>> getAllDistrict() async {
    var res = await client.get("/get-all-districts/701");
    var data = new List<DistrictModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new DistrictModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<WardModel>> getAllWard() async {
    var res = await client.get("/get-all-wards/70101");
    var data = new List<WardModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new WardModel.fromJson(v));
      });
    }

    return data;
  }
}

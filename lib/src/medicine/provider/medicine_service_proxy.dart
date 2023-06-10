import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/json_response_result.dart';
import 'package:suns_med/src/medicine/dto/detail_order_model.dart';
import 'package:suns_med/src/medicine/dto/medicine_model.dart';
import 'package:suns_med/src/medicine/dto/detail_medicine.dart';
import 'package:suns_med/src/medicine/dto/adress_shipping_model.dart';
import 'package:suns_med/src/medicine/dto/place_order_model.dart';
import 'package:suns_med/src/medicine/dto/order_model.dart';

class MedicineServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  MedicineServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<PagingResult<MedicineModel>> getMedicine(
      int pageNum, int pageSize) async {
    var res =
        await client.get("/Medicine?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<MedicineModel>.fromJson(
          res, (v) => new MedicineModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<PagingResult<MedicineModel>> getSearchMedicine(
      int pageNum, int pageSize, String key) async {
    var res = await client
        .get("/Medicine?pageNumber=$pageNum&pageSize=$pageSize&name=$key");
    if (res != null) {
      var result = PagingResult<MedicineModel>.fromJson(
          res, (v) => new MedicineModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<DetailMedicineModel> getDetailMedicine(String id) async {
    var res = await client.get("/Medicine/$id");
    if (res != null) {
      var result = DetailMedicineModel.fromJson(res);
      return result;
    }
    return null;
  }

  Future<DetailOrderModel> getDetailOrder(String id) async {
    var res = await client.get("/Order/$id");
    if (res != null) {
      var result = DetailOrderModel.fromJson(res);
      return result;
    }
    return null;
  }

  Future<PagingResult<UserAddressModel>> getAdressShipping() async {
    var res = await client.get("/ShippingAddress?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<UserAddressModel>.fromJson(
          res, (v) => new UserAddressModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<PagingResult<OrderModel>> getOrder(int pageNum, int pageSize) async {
    var res = await client.get("/Order?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<OrderModel>.fromJson(
          res, (v) => new OrderModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<String> setAdressShipping(AdressModel adressModel) async {
    var res = await client.post("/ShippingAddress", jsonEncode(adressModel));
    return res;
  }

  Future<String> setOrder(PlaceOrdersModel order) async {
    var res = await client.post("/Order", jsonEncode(order));
    return res;
  }
}

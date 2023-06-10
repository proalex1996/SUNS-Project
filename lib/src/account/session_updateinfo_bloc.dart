import 'dart:io';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/district_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/ward_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_update_model.dart';

class UpdateState {
  bool isUpdated;
  UserModel userModel;
  List<ProvinceModel> provinces;
  List<DistrictModel> districs;
  List<WardModel> wards;

  UpdateState(
      {this.isUpdated = false,
      this.userModel,
      this.provinces,
      this.districs,
      this.wards});
}

abstract class UpdateEvent {}

class LoadProvincesEvent extends UpdateEvent {}

class LoadDistrictEvent extends UpdateEvent {
  String provinceId;
  LoadDistrictEvent({this.provinceId});
}

class LoadWardsEvent extends UpdateEvent {
  String districtId;
  LoadWardsEvent({this.districtId});
}

class UpdateInForEvent extends UpdateEvent {
  String personID;
  String name;
  String address, province, district, ward;
  String email;
  String dateTime, phone;
  File image;
  int index;

  UpdateInForEvent(
      {this.email,
      this.address,
      this.province,
      this.district,
      this.ward,
      this.name,
      this.personID,
      this.dateTime,
      this.phone,
      this.image,
      this.index});
}

class UpdateBloc extends BlocBase<UpdateEvent, UpdateState> {
  UserUpdateModel _userUpdate = UserUpdateModel();
  @override
  void initState() {
    this.useGlobalLoading = false;
    this.state = new UpdateState();
    this.state.isUpdated = false;
    super.initState();
  }

  @override
  Future<UpdateState> mapEventToState(UpdateEvent event) async {
    if (event is UpdateInForEvent) {
      await update(
          event.personID,
          event.name,
          event.email,
          event.address,
          event.province,
          event.district,
          event.ward,
          event.dateTime,
          event.phone,
          event.image,
          event.index);
      this.state.isUpdated = true;
    } else if (event is LoadProvincesEvent) {
      await _getListProvince();
    } else if (event is LoadDistrictEvent) {
      await _getDistricts(event.provinceId);
    } else if (event is LoadWardsEvent) {
      await _getWards(event.districtId);
    }
    return this.state;
  }

  Future _getListProvince() async {
    final service = ServiceProxy().commonService;
    this.state.provinces = await service.getAllCities();
  }

  Future _getDistricts(String provinceId) async {
    final service = ServiceProxy().commonService;
    this.state.districs = await service.getDistricts(provinceId);
  }

  Future _getWards(String districtId) async {
    final service = ServiceProxy().commonService;
    this.state.wards = await service.getWards(districtId);
  }

  Future update(
      String _personID,
      String _name,
      String _email,
      String _address,
      String _province,
      String district,
      String ward,
      String _dateTime,
      String phone,
      File _image,
      int _index) async {
    final service = ServiceProxy();

    _userUpdate?.personalNumber = _personID;
    _userUpdate?.fullName = _name;
    _userUpdate?.email = _email;
    _userUpdate?.address = _address;
    _userUpdate?.gender = _index;
    _userUpdate?.avatar = "";
    _userUpdate?.ward = ward;
    _userUpdate?.district = district;
    _userUpdate?.province = _province;
    _userUpdate?.phoneNumber = phone;
    _userUpdate?.national = "";
    _userUpdate?.idCardBack = "";
    _userUpdate?.idCardFront = "";
    _userUpdate?.birthDay = _dateTime;

    this.state.userModel = await service.userService.updateUser(_userUpdate);
    await service.contactSeviceProxy.syncExamResult();
  }
}

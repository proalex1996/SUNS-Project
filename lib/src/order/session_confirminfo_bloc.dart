import 'dart:convert';
import 'dart:io';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_result.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/deep_link_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/user_wallet_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/dto/vnpay_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/dto/vnpay_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/order_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/detail_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/post_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/prescription_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/post_order_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/model/image_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConfirmState {
  OrderResult result;
  UserWalletMode userWallet;
  DeepLinkModel deepLink;
  CreateMomoResult momoResult;
  bool checkBalance;
  VNPayResult vnPayResult;
  String appointmentId;
  bool checkStateApointment;
  String orderId;
  OrderModelNew orderModelNew;
  bool checkPayment;
  bool checkStateOrder;
  bool orderPay;
  String urlResult;
  String vnPayResultLink;
  bool paid;
  DetailAppointmentModel detailAppointment;

  ConfirmState({
    this.result,
    this.userWallet,
    this.checkStateApointment = false,
    this.checkBalance = true,
    this.checkStateOrder = false,
    this.checkPayment = false,
    this.vnPayResultLink,
    this.urlResult,
    this.deepLink,
    this.vnPayResult,
    this.momoResult,
    this.orderModelNew,
    this.appointmentId,
    this.detailAppointment,
    this.orderId,
    this.orderPay,
    this.paid = false,
  });
}

enum PaymentForType { ServicePackage, Equipment }

abstract class ConfirmEvent {}

class EventReset extends ConfirmEvent {}

class EventConfirm extends ConfirmEvent {
  ContactModel contact;
  File image;
  String history, note;
  int userId;
  EventConfirm(
      {this.contact, this.image, this.history, this.note, this.userId});
}

class EventPostCreateAppointment extends ConfirmEvent {
  String firstHistory;
  int patientId;
  List<Object> prescriptionFiles;
  DateTime appoinmentTime;

  String note;
  String staffId;
  String servicePackageId;
  String name;
  String branchId;
  EventPostCreateAppointment(
      {this.patientId,
      this.firstHistory,
      this.prescriptionFiles,
      this.appoinmentTime,
      this.note,
      this.staffId,
      this.servicePackageId,
      this.name,
      this.branchId});
}

class EventResetStateCheckAppointment extends ConfirmEvent {}

class EventPostOrder extends ConfirmEvent {
  String equimentId;
  EventPostOrder({this.equimentId});
}

class ConfirmBloc extends BlocBase<ConfirmEvent, ConfirmState> {
  // static final ConfirmBloc _singleton = ConfirmBloc._internal();

  // factory ConfirmBloc() {
  //   return _singleton;
  // }

  // ConfirmBloc._internal();
  PostAppointmentModel _postAppointment = PostAppointmentModel();
  PostOrderModel _postOrderModel = PostOrderModel();
  CreateMomoModel createMomo = CreateMomoModel();
  VNPayModel createVNPay = VNPayModel();
  PrescriptionModel _prescription = PrescriptionModel();
  @override
  void initState() {
    this.state = new ConfirmState();
    this.state.checkStateApointment = false;
    this.state.checkStateOrder = false;
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Future<ConfirmState> mapEventToState(ConfirmEvent event) async {
    if (event is EventConfirm) {
      // await _createOrder(
      //     event.contact, event.userId, event.history, event.note, event.image);
    } else if (event is EventPostCreateAppointment) {
      this.state.checkStateApointment = await _postCreateAppointment(
          event.patientId,
          event.firstHistory,
          event.prescriptionFiles,
          event.appoinmentTime,
          event.note,
          event.staffId,
          event.servicePackageId,
          event.name,
          event.branchId);
      this.state.orderPay = false;

      if (this.state.checkStateApointment == true) {
        this.state.checkStateOrder =
            await _postOrder(null, this.state.appointmentId);
      }
    } else if (event is EventPostOrder) {
      this.state.checkStateOrder = await _postOrder(event.equimentId, null);
      this.state.orderPay = false;
    } else if (event is EventResetStateCheckAppointment) {
      this.state.checkPayment = false;
      this.state.checkStateApointment = false;
    }
    return this.state;
  }

  Future _postOrder(String equimentId, String appointmentId) async {
    final service = ServiceProxy().orderServiceProxy;

    _postOrderModel.appointmentId = appointmentId;
    _postOrderModel.equipmentId = equimentId;
    var res = await service.postOrderModel(_postOrderModel);
    if (res != null) {
      this.state.orderId = res;
      return true;
    }
    return false;
  }

  Future _postCreateAppointment(
      int patientId,
      String firstHistory,
      List<Object> prescriptionFile,
      DateTime appoinmentTime,
      String note,
      String staffId,
      String servicePackageId,
      String name,
      String branchId) async {
    final service = ServiceProxy();
    _postAppointment.contactId = patientId;
    _postAppointment.firstHistory = firstHistory;
    // for(int i = 0 ; i<prescriptionFile.length; i++){
    //   ImageUploadModel a = prescriptionFile[i];
    //    var imageBytes = await a.imageFile?.readAsBytes();
    // _postAppointment.prescriptionFile =
    //     imageBytes != null ? base64Encode(imageBytes) : null;
    // }

    _postAppointment.prescriptionFile = "";

    _postAppointment.appointmentTime = appoinmentTime;
    _postAppointment.note = note;
    _postAppointment.staffId = staffId;
    _postAppointment.servicePackageId = servicePackageId;
    _postAppointment.name = name;
    _postAppointment.branchId = branchId;
    var res =
        await service.companyServiceProxy.postAppointment(_postAppointment);

    if (res != null) {
      this.state.appointmentId = res;
      this.state.detailAppointment =
          await service.appointmentServiceProxy.getDetailAppointment(res);
      if (prescriptionFile != null && prescriptionFile.isNotEmpty) {
        for (int i = 0; i < prescriptionFile.length; i++) {
          ImageUploadModel a = prescriptionFile[i];
          var imageBytes = await a.imageFile?.readAsBytes();
          _prescription.imageFile =
              imageBytes != null ? base64Encode(imageBytes) : null;
          await service.companyServiceProxy
              .postPrescription(this.state.appointmentId, _prescription);
        }
        // _prescription.imageFile = prescriptionFile;

      }
      return true;
    } else {
      this.state.detailAppointment = await service.appointmentServiceProxy
          .getDetailAppointment(this.state.appointmentId);
    }

    return null;
  }
}

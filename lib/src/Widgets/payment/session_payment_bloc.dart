import 'dart:async';
import 'dart:io';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_result.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/deep_link_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/dto/vnpay_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/create_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/order_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PaymentState {
  DeepLinkModel deepLink;
  String urlResult;
  CreateMomoResult momoResult;
  OrderResult result;
  String vnPayResultLink;
  bool orderPay;
  bool paid;
  CreateAppointmentModel createAppointment;
  bool checkPayment;
  PaymentState(
      {this.deepLink,
      this.vnPayResultLink,
      this.momoResult,
      this.urlResult,
      this.result,
      this.checkPayment = false,
      this.createAppointment,
      this.paid = false});
}

abstract class PaymentEvent {}

class EventPaymentMomo extends PaymentEvent {
  OrderModelNew orderResult;
  EventPaymentMomo({this.orderResult});
}

class EventResetState extends PaymentEvent {}

class EventResetStatePayment extends PaymentEvent {}

class EventPaymentVNPay extends PaymentEvent {
  OrderModelNew orderResult;
  EventPaymentVNPay({this.orderResult});
}

class EventConfirmPaymentVnPay extends PaymentEvent {
  String query;
  String orderId;

  EventConfirmPaymentVnPay({this.query, this.orderId});
}

class EventPaymentOrder extends PaymentEvent {
  int paymentMethod;
  String orderId;
  EventPaymentOrder({this.paymentMethod, this.orderId});
}

class PaymentBloc extends BlocBase<PaymentEvent, PaymentState> {
  static final PaymentBloc _singleton = PaymentBloc._internal();

  factory PaymentBloc() {
    return _singleton;
  }

  PaymentBloc._internal();
  CreateAppointmentModel create = new CreateAppointmentModel();
  CreateMomoModel createMomo = CreateMomoModel();
  VNPayModel createVNPay = VNPayModel();

  @override
  void initState() {
    this.state = PaymentState();
    this.state.checkPayment = false;
    this.state.paid = false;
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Future<PaymentState> mapEventToState(PaymentEvent event) async {
    if (event is EventPaymentMomo) {
      await _createMomo(event.orderResult);
      // await _launchInApp(this.state.momoResult.payUrl);
    } else if (event is EventPaymentVNPay) {
      await _createVNPay(event.orderResult);
      // await _launchInApp(this.state.vnPayResultLink);
    } else if (event is EventResetState) {
      this.state.orderPay = false;
      this.state.checkPayment = false;
    } else if (event is EventResetStatePayment) {
      this.state.orderPay = false;
      this.state.checkPayment = false;
    } else if (event is EventPaymentOrder) {
      await _postOrderPay(event.orderId, event.paymentMethod);
    } else if (event is EventConfirmPaymentVnPay) {
      this.state.paid = await _confirmPaymentVnPay(event.query, event.orderId);
      this.state.urlResult = "";
    }
    return this.state;
  }

  Future _createMomo(OrderModelNew orderResult) async {
    final service = ServiceProxy().momoServiceProxy;
    createMomo.returnUrl = "https://suns.com.vn";
    createMomo.orderId = orderResult.code;
    createMomo.amount = orderResult.amount;
    createMomo.description = "Nạp tiền vào ứng dụng SUNS-MED";
    this.state.deepLink = await service.getDeepLink();
    this.state.momoResult = await service.createMomo(createMomo);
    this.state.urlResult = this.state.momoResult.payUrl;
    if (this.state.momoResult.payUrl != null ||
        this.state.momoResult.payUrl.isNotEmpty) {
      this.state.checkPayment = true;
    } else {
      this.state.checkPayment = false;
    }
  }

  Future _createVNPay(OrderModelNew orderResult) async {
    final service = ServiceProxy().vnPayServiceProxy;
    createVNPay.returnUrl =
        "http://uat-payment.sunsoftware.vn/api/vnpay/CreatePaymentUrl";
    createVNPay.orderId = orderResult.code;
    createVNPay.bankCode = "";
    createVNPay.locale = "vi";
    createVNPay.amount = orderResult.amount;
    createVNPay.orderDescription = "Nạp tiền vào ứng dụng SUNS-MED";
    var vnPayResultLink = await service.createVNPay(createVNPay);
    this.state.urlResult = vnPayResultLink;
    if (vnPayResultLink != null || vnPayResultLink.isNotEmpty) {
      this.state.checkPayment = true;
    } else {
      this.state.checkPayment = false;
    }
  }

  Future _postOrderPay(String orderId, int paymentMethod) async {
    final service = ServiceProxy();

    this.state.orderPay =
        await service.orderServiceProxy.postOrderPay(orderId, paymentMethod);
  }

  Future<bool> _confirmPaymentVnPay(
    String query,
    String orderId,
  ) async {
    // to do fix get confirm payment
    final service = ServiceProxy();
    var result = await service.vnPayServiceProxy.confirmPayment(query);
    if (result != null) {
      this.state.orderPay =
          await service.orderServiceProxy.postOrderPay(orderId, 4);

      return true;
    }
    return false;
  }
}

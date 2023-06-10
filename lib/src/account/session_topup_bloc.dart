import 'dart:math';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_result.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/deep_link_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/dto/vnpay_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class ChooseTopupState {
  int topupId;
  String vnPayResultLink;
  String urlResult;
  bool checkPayment;
  bool paid;
  DeepLinkModel deepLink;
  CreateMomoResult momoResult;
  ChooseTopupState(
      {this.topupId,
      this.vnPayResultLink,
      this.momoResult,
      this.deepLink,
      this.urlResult,
      this.checkPayment,
      this.paid});
}

abstract class ChooseTopupEvent {}

class EventTopup extends ChooseTopupEvent {
  int id;
  EventTopup({this.id});
}

class EventrechargeVnPay extends ChooseTopupEvent {
  int amount;
  EventrechargeVnPay({this.amount});
}

class EventrechargeMomo extends ChooseTopupEvent {
  int amount;
  EventrechargeMomo({this.amount});
}

class EventGetDeepLink extends ChooseTopupEvent {}

class EventResetStateReCharge extends ChooseTopupEvent {}

class EventConfirmReChargeVnPay extends ChooseTopupEvent {
  String query;
  EventConfirmReChargeVnPay({this.query});
}

class EventResetStateReChargeVnPay extends ChooseTopupEvent {}

class ChooseTopupBloc extends BlocBase<ChooseTopupEvent, ChooseTopupState> {
  static final ChooseTopupBloc _singleton = ChooseTopupBloc._internal();

  factory ChooseTopupBloc() {
    return _singleton;
  }

  ChooseTopupBloc._internal();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  VNPayModel createVNPay = VNPayModel();
  CreateMomoModel createMomo = CreateMomoModel();
  @override
  void initState() {
    this.state = new ChooseTopupState();
    this.state.topupId = 0;
    super.initState();
  }

  @override
  Future<ChooseTopupState> mapEventToState(ChooseTopupEvent event) async {
    if (event is EventTopup) {
      this.state = ChooseTopupState(topupId: event.id);
    } else if (event is EventrechargeVnPay) {
      await _createrechargeVNPay(event.amount);
    } else if (event is EventResetStateReCharge) {
      this.state.checkPayment = false;
    } else if (event is EventConfirmReChargeVnPay) {
      this.state.paid = await _confirmrechargeVnPay(event.query);
    } else if (event is EventResetStateReChargeVnPay) {
      this.state.paid = false;
    } else if (event is EventrechargeMomo) {
      await _createMomo(event.amount);
    } else if (event is EventGetDeepLink) {
      await _getDeepLink();
    }

    return this.state;
  }

  Future _getDeepLink() async {
    final service = ServiceProxy().momoServiceProxy;
    this.state.deepLink = await service.getDeepLink();
  }

  Future _createMomo(int amount) async {
    final service = ServiceProxy().momoServiceProxy;
    createMomo.returnUrl = "https://suns.com.vn";
    createMomo.orderId = "${getRandomString(5)}}";
    createMomo.amount = amount;
    createMomo.description = "Nạp tiền vào ứng dụng SUNS-MED";
    this.state.deepLink = await service.getDeepLink();
    this.state.momoResult = await service.createMomo(createMomo);
    this.state.urlResult = this.state.momoResult.payUrl;
    // if (this.state.momoResult.payUrl != null ||
    //     this.state.momoResult.payUrl.isNotEmpty) {
    //   this.state.checkPayment = true;
    // } else {
    //   this.state.checkPayment = false;
    // }
  }

  Future _createrechargeVNPay(int amount) async {
    final service = ServiceProxy().vnPayServiceProxy;
    createVNPay.returnUrl =
        "https://115.79.29.62:6311/api/vnpay/ConfirmPayment";
    createVNPay.orderId = "${getRandomString(5)}}";
    createVNPay.bankCode = "";
    createVNPay.locale = "vi";
    createVNPay.amount = amount;
    createVNPay.orderDescription = "Nạp tiền vào ứng dụng SUNS-MED";
    this.state.vnPayResultLink = await service.createVNPay(createVNPay);
    this.state.urlResult = this.state.vnPayResultLink;
    if (this.state.vnPayResultLink != null ||
        this.state.vnPayResultLink.isNotEmpty) {
      this.state.checkPayment = true;
    } else {
      this.state.checkPayment = false;
    }
  }

  Future<bool> _confirmrechargeVnPay(
    String query,
  ) async {
    // to do fix get confirm payment
    final service = ServiceProxy();
    var result = await service.vnPayServiceProxy.confirmPayment(query);
    if (result != null) {
      return true;
    }
    return false;
  }
}

import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/qr_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/user-form-qr_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class QrCodeState {
  UserFromQrCodeModel userFromQrCode;
  QrCodeState({this.userFromQrCode});
}

abstract class QrCodeEvent {}

class GenerateQrCodeEvent extends QrCodeEvent {
  QrModel qrModel;
  GenerateQrCodeEvent({this.qrModel});
}

class QrCodeBloc extends BlocBase<QrCodeEvent, QrCodeState> {
  @override
  void initState() {
    this.state = new QrCodeState();
    super.initState();
  }

  @override
  Future<QrCodeState> mapEventToState(QrCodeEvent event) async {
    if (event is GenerateQrCodeEvent) {
      await _generateQrcode(event.qrModel);
    }
    return this.state;
  }

  Future _generateQrcode(QrModel qrModel) async {
    final serviceProxy = ServiceProxy().newCommonServiceProxy;
    var res = await serviceProxy.inputQrCode(qrModel);
    this.state.userFromQrCode = res;
  }
}

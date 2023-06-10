import 'dart:convert';
import 'dart:typed_data';

import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/upload_avatar_model.dart';

class AvatarState {}

abstract class AvatarEvent {}

class UploadAvatarEvent extends AvatarEvent {
  Uint8List image;
  UploadAvatarEvent({this.image});
}

class AvatarBloc extends BlocBase<AvatarEvent, AvatarState> {
  static final AvatarBloc _singleton = AvatarBloc._internal();

  factory AvatarBloc() {
    return _singleton;
  }

  AvatarBloc._internal();
  UploadAvatarModel _uploadAvatar = new UploadAvatarModel();
  @override
  void initState() {
    this.state = new AvatarState();
    super.initState();
  }

  @override
  Future<AvatarState> mapEventToState(AvatarEvent event) async {
    if (event is UploadAvatarEvent) {
      await uploadAvatar(event.image);
    }
    return this.state;
  }

  Future uploadAvatar(Uint8List _image) async {
    final services = ServiceProxy();
    _uploadAvatar.avatar = _image != null ? base64Encode(_image) : null;
    await services.userService.uploadAvatar(_uploadAvatar);
  }
}

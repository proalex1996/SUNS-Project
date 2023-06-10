import 'dart:core';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/call/call_workflow.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';

class CommingCallInfo {
  bool isInCommingCall;
  CallInfo receiver;

  CommingCallInfo({
    this.isInCommingCall,
    this.receiver,
  });
}

class InCommingCall extends StatelessWidget {
  final CommingCallInfo info;

  const InCommingCall({
    Key key,
    @required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => InCommingCallProvider(),
        child: _InCommingCall(
          isInCommingCall: this.info.isInCommingCall,
          receiver: this.info.receiver,
        ));
  }
}

class InCommingCallProvider with ChangeNotifier {
  // bool hasTorch;
  // bool enableTorch;
  bool enableMicrophone;
  bool enableSpeakerphone;
  bool enableCamera;

  InCommingCallProvider({
    // this.hasTorch = false,
    // this.enableTorch = false,
    this.enableMicrophone = true,
    this.enableCamera = true,
    this.enableSpeakerphone = true,
  });

  // void toggleTorch() async {
  //   try {
  //     var status = !this.enableTorch;

  //     if (await WebRTCWorkflow().setTorch(status)) {
  //       this.enableTorch = status;
  //       notifyListeners();
  //     }
  //   } catch (e) {}
  // }

  void switchCamera() async {
    try {
      if (await WebRTCWorkflow().switchCamera()) {
        // this.hasTorch = await WebRTCWorkflow().hasTorch();
        notifyListeners();
      }
    } catch (e) {}
  }

  void toggleMicrophone() async {
    try {
      var status = !this.enableMicrophone;

      if (await WebRTCWorkflow().setMicrophoneMute(!status)) {
        this.enableMicrophone = status;
        notifyListeners();
      }
    } catch (e) {}
  }

  void toggleSpeakerphone() async {
    try {
      var status = !this.enableSpeakerphone;

      if (await WebRTCWorkflow().setSpeakerphone(status)) {
        this.enableSpeakerphone = status;
        notifyListeners();
      }
    } catch (e) {}
  }

  void toggleCamera() async {
    try {
      var status = !this.enableCamera;

      if (await WebRTCWorkflow().setCamera(status)) {
        this.enableCamera = status;
        // this.hasTorch = await WebRTCWorkflow().hasTorch();
        notifyListeners();
      }
    } catch (e) {}
  }
}

class _InCommingCall extends StatefulWidget {
  final bool isInCommingCall;
  final CallInfo receiver;

  _InCommingCall({
    this.isInCommingCall,
    this.receiver,
  });

  @override
  _InCommingCallState createState() => _InCommingCallState();
}

class _InCommingCallState extends State<_InCommingCall> {
  @override
  void initState() {
    super.initState();
    if (SessionBloc().state?.user?.id != null) {
      CallBloc().dispatch(EventActivateScreenCall(
        isInCommingCall: this.widget.isInCommingCall,
        receiver: this.widget.receiver,
      ));
    } else {
      var first = false;
      SessionBloc().stream.listen((event) {
        if (event.user?.id != null) {
          if (!first) {
            first = true;
            CallBloc().dispatch(EventActivateScreenCall(
              isInCommingCall: this.widget.isInCommingCall,
              receiver: this.widget.receiver,
            ));
          }
        }
      });

      SessionBloc().dispatch(EventAutoLoginSession());
    }
  }

  @override
  void deactivate() {
    CallBloc().dispatch(EventDeactivateScreenCall());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            // image: AssetImage("assets/images/background_call.png"),
            image: AssetImage(
              "assets/images/background.png",
            ),
            colorFilter:
                ColorFilter.mode(AppColor.deepBlue, BlendMode.colorBurn),
            fit: BoxFit.cover,
          ),
        ),
        child: OrientationBuilder(builder: (context, orientation) {
          return StreamBuilder(
            stream: CallWorkflow().callStateStream,
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<CallState> snapshot) {
              return Container(
                child: Stack(children: <Widget>[
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: CallWorkflowSetting().remoteCamera,
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    top: 60.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: CallWorkflowSetting().localCamera,
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: renderWaitingCall(
                                CallWorkflow().callAction,
                                CallWorkflow().callState,
                                CallWorkflow().receiver,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: renderListButton(
                                  CallWorkflow().callAction,
                                  CallWorkflow().callState),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 20.0,
                    child: _renderButtonRelativeCamera(),
                  ),
                ]),
              );
            },
          );
        }),
      ),
    );
  }

  _switchCameraButton() {
    return FlatButton(
      height: 30,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.autorenew),
      ),
      onPressed: () {
        context.read<InCommingCallProvider>().switchCamera();
      },
    );
  }

  // _toggleTorchButton() {
  //   return FlatButton(
  //     height: 30,
  //     child: CircleAvatar(
  //       backgroundColor: Colors.red,
  //       child: Consumer<InCommingCallProvider>(
  //         builder: (context, provider, child) {
  //           return provider.enableTorch != true
  //               ? Icon(Icons.flash_off)
  //               : Icon(Icons.flash_on);
  //         },
  //       ),
  //     ),
  //     onPressed: () {
  //       context.read<InCommingCallProvider>().toggleTorch();
  //     },
  //   );
  // }

  _renderButtonRelativeCamera() {
    return Consumer<InCommingCallProvider>(
      builder: (context, provider, child) {
        var widgets = <Widget>[];
        // if (provider.hasTorch == true) {
        //   widgets = [_switchCameraButton(), _toggleTorchButton()];
        // } else {
        //   widgets = [_switchCameraButton()];
        // }
        widgets = [_switchCameraButton()];

        return Row(
          children: widgets,
        );
      },
    );
  }

  _rejectButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: Colors.red.shade400,
            child: Icon(Icons.call_end),
          ),
          onPressed: () {
            CallBloc().dispatch(EventCallAction(action: CallAction.Reject));
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Từ chối",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  _acceptButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: Colors.green.shade400,
            child: Icon(Icons.phone, color: Colors.white),
          ),
          onPressed: () {
            CallBloc().dispatch(EventCallAction(action: CallAction.Accept));
            // CallHubConnection().action(CallAction.Accept);
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Trả lời",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  _endButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: Colors.red.shade400,
            child: Icon(Icons.call_end),
          ),
          onPressed: () {
            CallBloc().dispatch(EventCallAction(action: CallAction.End));
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Kết thúc",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  _cancelButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: Colors.red.shade400,
            child: Icon(Icons.call_end),
          ),
          onPressed: () {
            CallBloc().dispatch(EventCallAction(action: CallAction.Cancel));
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Hủy",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  _audioButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: AppColor.ocenBlue,
            child: Consumer<InCommingCallProvider>(
              builder: (context, provider, child) {
                return provider.enableMicrophone != true
                    ? Icon(Icons.mic_off)
                    : Icon(Icons.mic);
              },
            ),
          ),
          onPressed: () {
            context.read<InCommingCallProvider>().toggleMicrophone();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Micro",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  _videoButton() {
    return Column(
      children: [
        FlatButton(
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: AppColor.ocenBlue,
            child: Consumer<InCommingCallProvider>(
              builder: (context, provider, child) {
                return provider.enableCamera != true
                    ? Icon(Icons.missed_video_call)
                    : Icon(Icons.video_call);
              },
            ),
          ),
          onPressed: () {
            context.read<InCommingCallProvider>().toggleCamera();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Video",
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16),
        ),
      ],
    );
  }

  @protected
  List<Widget> renderListButton(CallAction action, CallState callState) {
    var widgets = <Widget>[];

    switch (callState) {
      case CallState.Calling:
        widgets = [_audioButton(), _endButton(), _videoButton()];
        break;
      case CallState.Connecting:
        if (action == CallAction.Call) {
          widgets = [_audioButton(), _cancelButton(), _videoButton()];
        } else {
          widgets = [_rejectButton(), _acceptButton(), _videoButton()];
        }
        break;
      case CallState.Connected:
        if (action == CallAction.Call) {
          widgets = [_audioButton(), _cancelButton(), _videoButton()];
        } else {
          widgets = [_rejectButton(), _acceptButton(), _videoButton()];
        }
        break;
      case CallState.End:
        widgets = [];
        WidgetsBinding.instance
            .addPostFrameCallback((x) => Navigator.pop(context));
        break;
      default:
    }

    return widgets;
  }

  @protected
  List<Widget> renderWaitingCall(
    CallAction action,
    CallState callState,
    CallInfo callInfo,
  ) {
    var message = "";
    var widgets = <Widget>[];

    switch (callState) {
      case CallState.Calling:
        // result = "Đang gọi";
        break;
      case CallState.Connecting:
        if (action == CallAction.Call) {
          message = "Đang kết nối";
          widgets = _renderInfo(callInfo, message);
        } else {
          // result = "Cuộc gọi đến";
        }
        break;
      case CallState.Connected:
        if (action == CallAction.Call) {
          message = "Đang đổ chuông";
          widgets = _renderInfo(callInfo, message);
        } else {
          message = "Cuộc gọi đến";
          widgets = _renderInfo(callInfo, message);
        }
        break;
      case CallState.End:
        message = "Kết thúc";
        break;
      default:
    }

    return widgets;
  }

  List<Widget> _renderInfo(CallInfo callInfo, String message) {
    return <Widget>[
      (callInfo?.avatar == null)
          ? CircleAvatar(
              // minRadius: 70,
              radius: 70,
              backgroundColor: AppColor.deepBlue,
              child: Image.asset(
                'assets/images/avatar2.png',
                height: 123,
                fit: BoxFit.cover,
              )
              // : Container(
              //     decoration: BoxDecoration(shape: BoxShape.circle),
              //     height: 200,
              //     width: 200,
              //     child: Image.network(
              //       callInfo?.avatar,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              )
          : CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(callInfo?.avatar),
            ),
      SizedBox(
        height: 20,
      ),
      Text(
        callInfo.name ?? "",
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        message ?? "",
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            // fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18),
      ),
    ];
  }
}

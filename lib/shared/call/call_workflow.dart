import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/signalr/hub_connection_base.dart';
import 'package:suns_med/shared/user_friendly_exception.dart';
import 'package:flushbar/flushbar.dart';

enum CallAction { Call, Cancel, Accept, Reject, End }

enum CallState { Connecting, Connected, Calling, End }

enum CallingState { Calling, Disconnected, Reconnecting }

enum CameraState { On, Off, Denied }

enum MicrophoneState { On, Off, Denied }

enum SpeakerState { On, Off }

class CallInfo {
  String id;
  String name;
  String avatar;

  CallInfo({@required this.id, @required this.name, this.avatar});

  CallInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;

    return data;
  }
}

class CallWorkflowCallback {
  Future Function() onCall;
  Future Function() onAccept;
  Future Function() onCancel;
  Future Function() onReject;
  Future Function() onEnd;

  CallWorkflowCallback(
      {this.onCall, this.onAccept, this.onCancel, this.onReject, this.onEnd});
}

class CallWorkflow {
  static final CallWorkflow _instance = CallWorkflow._internal();
  CallWorkflow._internal();

  factory CallWorkflow() {
    return _instance;
  }
  Timer _waitingFirstRequest;
  Timer _timeout;
  final _callStateController = StreamController<CallState>();
  Stream<CallState> _callStateStream;
  Stream<CallState> get callStateStream =>
      _callStateStream ??
      (_callStateStream = _callStateController.stream.asBroadcastStream());

  CallState _callState;
  CallState get callState => _callState;
  set callState(CallState callState) {
    _callState = callState;
    _callStateController.sink.add(_callState);
  }

  CallAction callAction;
  CallingState callingState;
  CameraState cameraState;
  MicrophoneState microphoneState;
  SpeakerState speakerState;
  DateTime start;
  DateTime end;
  Future Function() onClear;
  Future Function() onReceiveNotifyActionCall;
  Future Function() onTrySendConnect;
  Future Function() onTimeout;
  CallWorkflowCallback onAction;
  CallWorkflowCallback onReceiveAction;
  CallInfo get self {
    return getSelfInfo();
  }

  CallInfo receiver;
  CallInfo Function() getSelfInfo;

  Future<bool> action(CallAction action, CallInfo receiver) async {
    var result = false;

    switch (action) {
      case CallAction.Call:
        if (receiver?.id == null)
          throw UserFriendlyException(
              "Không thể gọi khi không tìm thấy thông tin người nhận cuộc gọi!");

        await this.clear();
        this.receiver = receiver;
        this.callAction = action;
        await this.onAction?.onCall?.call();
        this.callState = CallState.Connecting;
        await _initAutoTrySendConnect();
        await _initAutoCheckTimeout(60);
        result = true;
        break;
      case CallAction.Cancel:
        if (this.receiver?.id == null)
          throw UserFriendlyException(
              "Không thể hủy cuộc gọi khi không tìm thấy thông tin người nhận cuộc gọi!");

        this.callAction = action;
        await this.onAction?.onCancel?.call();
        this.callState = CallState.End;
        result = true;
        break;
      case CallAction.Accept:
        if (this.receiver?.id == null)
          throw UserFriendlyException(
              "Không thể bắt máy khi không tìm thấy thông tin người nhận cuộc gọi!");

        this.callAction = action;
        await this.onAction?.onAccept?.call();
        this.callState = CallState.Calling;
        result = true;
        break;
      case CallAction.Reject:
        if (this.receiver?.id == null)
          throw UserFriendlyException(
              "Không thể từ chối cuộc gọi khi không tìm thấy thông tin người nhận cuộc gọi!");

        this.callAction = action;
        await this.onAction?.onReject?.call();
        this.callState = CallState.End;
        result = true;
        break;
      case CallAction.End:
        if (this.receiver?.id == null)
          throw UserFriendlyException(
              "Không thể kết thúc cuộc gọi khi không tìm thấy thông tin người nhận cuộc gọi!");

        this.callAction = action;
        await this.onAction?.onEnd?.call();
        this.callState = CallState.End;
        result = true;
        break;
      default:
        throw Exception("ArgumentOutOfRangeException");
    }

    return result;
  }

  Future<bool> receiveAction(CallAction senderAction, CallInfo sender) async {
    var result = false;
    if (sender?.id == null) return result;

    switch (senderAction) {
      case CallAction.Call:
        if (this.callState == null || this.callState == CallState.End) {
          if (sender.id == this.self.id) return result;

          await this.clear();
          this.receiver = sender;
          await this.onReceiveAction?.onCall?.call();
          this.callState = CallState.Connected;
          await _initAutoCheckTimeout(60);
          result = true;
        } else {
          //Todo display message: there is another user calling you; action: accept incoming call and end current call
        }
        break;
      case CallAction.Cancel:
        if (this.receiver?.id == sender.id && this.callState != CallState.End) {
          await this.onReceiveAction?.onCancel?.call();
          this.callState = CallState.End;
          result = true;
        } else {
          //Todo Log warning
        }
        break;
      case CallAction.Accept:
        if (this.receiver?.id == sender.id &&
            this.callState != CallState.Calling) {
          await this.onReceiveAction?.onAccept?.call();
          this.callState = CallState.Calling;
          result = true;
        }
        break;
      case CallAction.Reject:
        if (this.receiver?.id == sender.id && this.callState != CallState.End) {
          await this.onReceiveAction?.onReject?.call();
          this.callState = CallState.End;
          result = true;
        }
        break;
      case CallAction.End:
        if (this.receiver?.id == sender.id && this.callState != CallState.End) {
          await this.onReceiveAction?.onEnd?.call();
          this.callState = CallState.End;
          result = true;
        }
        break;
      default:
        break;
    }

    return result;
  }

  Future receiveNotifyActionCall(String senderId) async {
    if (senderId == null ||
        senderId.isEmpty ||
        senderId == this.self.id ||
        senderId != this.receiver?.id) return;

    if (this.callAction == CallAction.Call &&
        this.callState == CallState.Connecting) {
      await this.onReceiveNotifyActionCall?.call();
      this.callState = CallState.Connected;
    }
  }

  Future _initAutoTrySendConnect() async {
    _waitingFirstRequest = Timer.periodic(Duration(seconds: 5), (timer) async {
      timer.cancel();
      _waitingFirstRequest?.cancel();
      print('_waitingFirstRequest cancel');
      if (this.callState == CallState.Connecting) {
        await this.onTrySendConnect?.call();
      }

      _waitingFirstRequest = null;
    });
  }

  Future _initAutoCheckTimeout(int seconds) async {
    _timeout = Timer.periodic(Duration(seconds: seconds), (timer) async {
      timer.cancel();
      _timeout?.cancel();
      print('_initAutoCheckTimeout cancel');
      if ((this.callState == CallState.Connecting &&
              this.callAction == CallAction.Call) ||
          (this.callState == CallState.Connected &&
              this.callAction != CallAction.Call)) {
        this.callAction = CallAction.End;
        await this.onAction?.onEnd?.call();
        this.callState = CallState.End;
        await this.onTimeout?.call();
      }

      _timeout = null;
    });
  }

  Future clear() async {
    this.callAction = null;
    this.callState = null;
    this.receiver = null;
    await this.onClear?.call();
  }

  dispose() {
    _callStateController.close();
  }
}

class WebRTCWorkflow {
  static final WebRTCWorkflow _instance = WebRTCWorkflow._internal();
  WebRTCWorkflow._internal();

  factory WebRTCWorkflow() {
    return _instance;
  }

  MediaStream _localStream;
  RTCPeerConnection _peerConnection;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer get localRenderer {
    return _localRenderer;
  }

  RTCVideoRenderer get remoteRenderer {
    return _remoteRenderer;
  }

  Widget get localCamera {
    return RTCVideoView(localRenderer, mirror: true);
  }

  Widget get remoteCamera {
    return RTCVideoView(remoteRenderer);
  }

  final _remoteCandidates = [];
  RTCSessionDescription offerDescription;
  RTCSessionDescription answerDescription;
  RTCSessionDescription remoteDescription;
  Function(dynamic type, dynamic data) onSendInfo;

  final mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': {
      'mandatory': {
        'minWidth':
            '1280', // Provide your own width, height and frame rate here
        'minHeight': '720',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  var configuration = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  final offerSdpConstraints = <String, dynamic>{
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  final loopbackConstraints = <String, dynamic>{
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': false},
    ],
  };

  Future _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _onSignalingState(RTCSignalingState state) {
    print(state);
  }

  void _onIceGatheringState(RTCIceGatheringState state) {
    print(state);
  }

  void _onIceConnectionState(RTCIceConnectionState state) {
    print(state);
  }

  void _onAddStream(MediaStream stream) {
    print('addStream: ' + stream.id);
    _remoteRenderer.srcObject = stream;
  }

  void _onRemoveStream(MediaStream stream) async {
    await _remoteRenderer.srcObject?.dispose();
    _remoteRenderer.srcObject = null;
  }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ' + candidate.candidate);
    this.onSendInfo("IceCandidate", candidate.toMap());
  }

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
  }

  Future<void> _createPeerConnection() async {
    // _localStream = await MediaDevices.getUserMedia(mediaConstraints);
    // _localRenderer.srcObject = _localStream;
    _peerConnection =
        await createPeerConnection(configuration, loopbackConstraints);

    _peerConnection.onSignalingState = _onSignalingState;
    _peerConnection.onIceGatheringState = _onIceGatheringState;
    _peerConnection.onIceConnectionState = _onIceConnectionState;
    _peerConnection.onAddStream = _onAddStream;
    _peerConnection.onRemoveStream = _onRemoveStream;
    _peerConnection.onIceCandidate = _onCandidate;
    _peerConnection.onRenegotiationNeeded = _onRenegotiationNeeded;

    await _peerConnection.addStream(_localStream);
  }

  Future _clear() async {
    this.offerDescription = null;
    this.answerDescription = null;
    this.remoteDescription = null;
    await _peerConnection?.close();
    await _peerConnection?.dispose();
    _peerConnection = null;
    await _localStream?.dispose();
    _localStream = null;

    if (_localRenderer.srcObject != null) {
      await _localRenderer.srcObject.dispose();
      _localRenderer.srcObject = null;
    }

    if (_remoteRenderer.srcObject != null) {
      await _remoteRenderer.srcObject.dispose();
      _remoteRenderer.srcObject = null;
    }

    _remoteCandidates.clear();
  }

  Future initLocalCameraBeforeMakeCall() async {
    if (_localStream == null) {
      await this._initRenderers();
      _localStream = await MediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;
    }
  }

  Future onListenInfo(type, info) async {
    if (type == "offer") {
      if (this.offerDescription != null) return; //Todo log warning
      // don't call _clear method
      await initLocalCameraBeforeMakeCall();
      await this._createPeerConnection();
      this.remoteDescription = RTCSessionDescription(info['sdp'], info['type']);
      await _peerConnection.setRemoteDescription(this.remoteDescription);
      this.answerDescription =
          await _peerConnection.createAnswer(offerSdpConstraints);
      await _peerConnection.setLocalDescription(this.answerDescription);

      this.onSendInfo("answer", this.answerDescription.toMap());

      if (this._remoteCandidates.length > 0) {
        _remoteCandidates.forEach((candidate) async {
          await _peerConnection.addCandidate(candidate);
        });

        _remoteCandidates.clear();
      }
    }

    if (type == "answer") {
      if (_peerConnection != null) {
        this.remoteDescription =
            RTCSessionDescription(info['sdp'], info['type']);
        await _peerConnection.setRemoteDescription(this.remoteDescription);
      }
    }

    if (type == "IceCandidate") {
      var candidate = RTCIceCandidate(
        info['candidate'],
        info['sdpMid'],
        info['sdpMLineIndex'],
      );

      if (_peerConnection != null) {
        await _peerConnection.addCandidate(candidate);
      } else {
        _remoteCandidates.add(candidate);
      }
    }
  }

  Future makeCall() async {
    if (_peerConnection != null) return; //Todo Log warning

    await initLocalCameraBeforeMakeCall();
    await this._createPeerConnection();
    this.offerDescription =
        await _peerConnection.createOffer(offerSdpConstraints);
    await _peerConnection.setLocalDescription(this.offerDescription);
    this.onSendInfo("offer", this.offerDescription.toMap());
  }

  Future hangUp() async {
    await _clear();
  }

  Future<bool> setTorch(bool isTorchOn) async {
    final videoTrack = _getVideoTrack();
    final has = await videoTrack?.hasTorch();

    if (has == true) {
      await videoTrack.setTorch(isTorchOn);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasTorch() async {
    final videoTrack = _getVideoTrack();
    if (videoTrack == null) return false;
    final result = await videoTrack.hasTorch();

    return result;
  }

  Future<bool> switchCamera() async {
    final videoTrack = _getVideoTrack();
    if (videoTrack == null) return false;

    try {
      var result = await videoTrack.switchCamera();
      return result;
    } catch (e) {}

    return false;
  }

  Future<bool> setMicrophoneMute(bool mute) async {
    final videoTrack = _getVideoTrack();

    if (videoTrack != null) {
      videoTrack.setMicrophoneMute(mute);
      return true;
    }

    return false;
  }

  Future<bool> setSpeakerphone(bool enable) async {
    final videoTrack = _getVideoTrack();

    if (videoTrack != null) {
      videoTrack.enableSpeakerphone(enable);
      return true;
    }

    return false;
  }

  Future<bool> setCamera(bool enable) async {
    final videoTrack = _getVideoTrack();

    if (videoTrack != null) {
      videoTrack.enabled = enable;
      return true;
    }

    return false;
  }

  MediaStreamTrack _getVideoTrack() {
    if (_localStream == null) return null;

    return _localStream
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video', orElse: () => null);
  }

  @mustCallSuper
  void dispose() {
    _clear();
  }
}

class CallHubConnection extends HubConnectionBase {
  static final CallHubConnection _instance = CallHubConnection._internal();
  CallHubConnection._internal();

  factory CallHubConnection() {
    return _instance;
  }

  @protected
  @override
  String getUrl() {
    var messengerBaseUrl = AppConfig().messengerBaseUrl;

    if (messengerBaseUrl != null && messengerBaseUrl.isNotEmpty) {
      messengerBaseUrl = Uri.parse(messengerBaseUrl).origin;

      return '$messengerBaseUrl/hubs/WebRTCCallHub';
    }

    return null;
  }
}

abstract class EventCall {}

class EventCallAction extends EventCall {
  CallAction action;
  CallInfo receiver;
  EventCallAction({
    this.action,
    this.receiver,
  });
}

class EventActivateScreenCall extends EventCall {
  bool isInCommingCall;
  CallInfo receiver;
  EventActivateScreenCall({
    this.isInCommingCall,
    this.receiver,
  });
}

class EventDeactivateScreenCall extends EventCall {}

class StateCall {}

class CallBloc extends BlocBase<EventCall, StateCall> {
  static final CallBloc _instance = CallBloc._internal();
  CallBloc._internal();

  factory CallBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new StateCall();
    this.useGlobalLoading = false;
    super.initState();
  }

  @override
  Future<StateCall> mapEventToState(EventCall event) async {
    if (event is EventCallAction) {
      await CallWorkflow().action(event.action, event.receiver);
    } else if (event is EventActivateScreenCall) {
      if (event.isInCommingCall != true) {
        await CallWorkflow().action(CallAction.Call, event.receiver);
      } else {
        await CallWorkflow().receiveAction(CallAction.Call, event.receiver);
      }
    } else if (event is EventDeactivateScreenCall) {
      await CallWorkflow().clear();
    }

    return this.state;
  }
}

class CallWorkflowSetting {
  static final CallWorkflowSetting _instance = CallWorkflowSetting._internal();
  CallWorkflowSetting._internal();

  factory CallWorkflowSetting() {
    return _instance;
  }

  Function(CallInfo) onReceiveActionCall;
  // Function() onActionCall;

  Widget get localCamera {
    return WebRTCWorkflow().localCamera;
  }

  Widget get remoteCamera {
    return WebRTCWorkflow().remoteCamera;
  }

  init() {
    CallWorkflow().getSelfInfo = () {
      var user = SessionBloc().state.user;

      return CallInfo(id: user.id, name: user.fullName, avatar: user.avatar);
    };

    CallWorkflow().onClear = () async {
      await WebRTCWorkflow().hangUp();
    };

    CallWorkflow().onReceiveNotifyActionCall = () async {};
    CallWorkflow().onTimeout = () async {
      _showTimeout();
    };

    CallWorkflow().onTrySendConnect = () async {
      await _sendTrySendConnect();
    };

    CallWorkflow().onAction = CallWorkflowCallback(
      onCall: () async {
        await WebRTCWorkflow().initLocalCameraBeforeMakeCall();
        await _sendAction(CallAction.Call);
      },
      onAccept: () async {
        // await WebRTCWorkflow().makeCall();
        await _sendAction(CallAction.Accept);
      },
      onCancel: () async {
        await WebRTCWorkflow().hangUp();
        await _sendAction(CallAction.Cancel);
      },
      onEnd: () async {
        await WebRTCWorkflow().hangUp();
        await _sendAction(CallAction.End);
      },
      onReject: () async {
        await WebRTCWorkflow().hangUp();
        await _sendAction(CallAction.Reject);
      },
    );

    CallWorkflow().onReceiveAction = CallWorkflowCallback(
      onCall: () async {
        await WebRTCWorkflow().initLocalCameraBeforeMakeCall();
        await _sendNotifyActionCall();
      },
      onAccept: () async {
        await WebRTCWorkflow().makeCall();
      },
      onCancel: () async {
        await WebRTCWorkflow().hangUp();
      },
      onEnd: () async {
        await WebRTCWorkflow().hangUp();
      },
      onReject: () async {
        await WebRTCWorkflow().hangUp();
      },
    );

    CallHubConnection().onListen("ReceiveNotifyActionCall", (arguments) {
      if (arguments.length == 1) {
        print('ReceiveNotifyActionCall ${arguments[0]}');

        var senderId = arguments[0]?.toString();
        CallWorkflow().receiveNotifyActionCall(senderId);
      }
    });

    CallHubConnection().onListen("ReceiveAction", (arguments) async {
      if (arguments.length == 3) {
        print(
            'ReceiveAction ${arguments[0]} - ${arguments[1]} - ${arguments[2]} ');

        var senderId = arguments[0]?.toString();
        int temp = arguments[1];
        var action = CallAction.values[temp];
        var senderInfo = CallInfo.fromJson(jsonDecode(arguments[2]));

        if (senderInfo.id != senderId) {
          // Log warning
          return;
        }

        var result = await CallWorkflow().receiveAction(
          action,
          senderInfo,
        );

        if (action == CallAction.Call && result == true) {
          this.onReceiveActionCall?.call(senderInfo);
        }
      }
    });

    WebRTCWorkflow().onSendInfo = (type, data) {
      CallHubConnection().invoke(
        "SendWebRTCAction",
        args: [
          CallWorkflow().receiver.id,
          type,
          data,
        ],
      );
    };

    CallHubConnection().onListen(
      "ReceiveWebRTCAction",
      (arguments) {
        if (arguments.length == 3) {
          print(
              'ReceiveWebRTCAction ${arguments[0]} - ${arguments[1]} - ${arguments[2]} ');

          var senderId = arguments[0]?.toString();
          var type = arguments[1];
          var info = arguments[2];

          if (CallWorkflow().self.id == senderId ||
              CallWorkflow().receiver?.id == null ||
              CallWorkflow().receiver.id != senderId) return;

          WebRTCWorkflow().onListenInfo(type, info);
        }
      },
    );
  }

  Future _sendAction(CallAction action) async {
    var receiver = CallWorkflow().receiver;
    var self = CallWorkflow().self;
    await CallHubConnection().invoke("SendAction", args: [
      receiver.id,
      action.index,
      jsonEncode(self.toJson()),
    ]);
  }

  Future _sendNotifyActionCall() async {
    var receiver = CallWorkflow().receiver;
    await CallHubConnection().invoke("SendNotifyActionCall", args: [
      receiver.id,
    ]);
  }

  Future _sendTrySendConnect() async {
    var receiver = CallWorkflow().receiver;
    await CallHubConnection().invoke("TrySendConnect", args: [
      receiver.id,
    ]);
  }

  Future _showTimeout() async {
    await Future.delayed(Duration(seconds: 2));
    var context = AppConfig().navigatorKey.currentState.overlay.context;

    Flushbar(
      title: "Cuộc gọi đã kết thúc",
      message: "Cuộc gọi đã kết thúc",
      duration: Duration(seconds: 1),
      borderRadius: 20,
      icon: Icon(
        Icons.check_circle_outline_sharp,
        color: Colors.green,
      ),
      mainButton: Row(
        children: [
          // FlatButton(
          //   onPressed: () async {
          //   },
          //   child: Text(
          //     "Ok",
          //     style:TextStyle(
          //       fontFamily: 'Montserrat-M',color: AppColor.white),
          //   ),
          // ),
          // FlatButton(
          //   onPressed: () async {
          //     Navigator.of(context).pop();
          //   },
          //   child: Text(
          //     "Cancle",
          //     style:TextStyle(
          //        fontFamily: 'Montserrat-M',color: AppColor.white),
          //   ),
          // ),
        ],
      ),
    )..show(context);
  }
}

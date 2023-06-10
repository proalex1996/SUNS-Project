import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef void OnMessageCallback(String tag, dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

const CLIENT_ID_EVENT = 'client-id-event';
const OFFER_EVENT = 'offer-event';
const ANSWER_EVENT = 'answer-event';
const ICE_CANDIDATE_EVENT = 'ice-candidate-event';

class SimpleWebSocket {
  String _url;
  IO.Socket _socket;
  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnCloseCallback onClose;
  SimpleWebSocket(this._url);

  connect() async {
    try {
      _socket = IO.io(_url, <String, dynamic>{
        'transports': ['websocket']
      });
      // Dart client
      _socket.on('connect', (_) {
        print('connected');
        onOpen();
      });
      _socket.on(CLIENT_ID_EVENT, (data) {
        onMessage(CLIENT_ID_EVENT, data);
      });
      _socket.on(OFFER_EVENT, (data) {
        onMessage(OFFER_EVENT, data);
      });
      _socket.on(ANSWER_EVENT, (data) {
        onMessage(ANSWER_EVENT, data);
      });
      _socket.on(ICE_CANDIDATE_EVENT, (data) {
        onMessage(ICE_CANDIDATE_EVENT, data);
      });
      _socket.on('exception', (e) => print('Exception: $e'));
      _socket.on('connect_error', (e) => print('Connect error: $e'));
      _socket.on('disconnect', (e) {
        print('disconnect');
        onClose(0, e);
      });
      _socket.on('fromServer', (_) => print(_));
    } catch (e) {
      this.onClose(500, e.toString());
    }
  }

  send(event, data) {
    if (_socket != null) {
      _socket.emit(event, data);
      print('send: $event - $data');
    }
  }

  // send(data) {
  //   if (_socket != null) {
  //     _socket.add(data);
  //     print('send: $data');
  //   }
  // }

  close() {
    if (_socket != null) _socket.close();
  }

  // Future<WebSocket> _connectForSelfSignedCert(url) async {
  //   try {
  //     Random r = new Random();
  //     String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
  //     HttpClient client = HttpClient(context: SecurityContext());
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) {
  //       print(
  //           'SimpleWebSocket: Allow self-signed certificate => $host:$port. ');
  //       return true;
  //     };

  //     HttpClientRequest request =
  //         await client.getUrl(Uri.parse(url)); // form the correct url here
  //     request.headers.add('Connection', 'Upgrade');
  //     request.headers.add('Upgrade', 'websocket');
  //     request.headers.add(
  //         'Sec-WebSocket-Version', '13'); // insert the correct version here
  //     request.headers.add('Sec-WebSocket-Key', key.toLowerCase());

  //     HttpClientResponse response = await request.close();
  //     // ignore: close_sinks
  //     Socket socket = await response.detachSocket();
  //     var webSocket = WebSocket.fromUpgradedSocket(
  //       socket,
  //       protocol: 'signaling',
  //       serverSide: false,
  //     );

  //     return webSocket;
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}

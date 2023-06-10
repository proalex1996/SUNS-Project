import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/unauthorized_access_exception.dart';
import 'package:suns_med/shared/user_friendly_exception.dart';
import 'json_response_result.dart';

class HttpClient {
  String baseUrl;
  String prefix;
  AppAuthService appAuthService;
  dynamic Function(Response) convertResponse;

  HttpClient(
      {@required this.baseUrl,
      @required this.prefix,
      this.appAuthService,
      this.convertResponse}) {
    baseUrl = Uri.parse(baseUrl).origin + prefix;
  }

  // Future<Response> _head(url, {Map<String, String> headers}) =>
  //     _sendUnstreamed('HEAD', url, headers);

  Future<Response> _get(url, {Map<String, String> headers}) =>
      _sendUnstreamed('GET', url, headers);

  Future<Response> _post(url,
          {Map<String, String> headers, body, Encoding encoding}) =>
      _sendUnstreamed('POST', url, headers, body, encoding);

  Future<Response> _put(url,
          {Map<String, String> headers, body, Encoding encoding}) =>
      _sendUnstreamed('PUT', url, headers, body, encoding);

  // Future<Response> _patch(url,
  //         {Map<String, String> headers, body, Encoding encoding}) =>
  //     _sendUnstreamed('PATCH', url, headers, body, encoding);

  Future<Response> _delete(url, {Map<String, String> headers}) =>
      _sendUnstreamed('DELETE', url, headers);

  Future<Uint8List> readBytes(url, {Map<String, String> headers}) async {
    final response = await _get(url, headers: headers);
    _checkResponseSuccess(response);

    return response.bodyBytes;
  }

  Future<dynamic> get(url) async {
    final response = await _get(url);

    return _convertResponse(response);
  }

  Future<dynamic> post(url, body) async {
    final response = await _post(url, body: body);
    // print(response.body);
    return _convertResponse(response);
  }

  Future<dynamic> put(url, body) async {
    final response = await _put(url, body: body);

    return _convertResponse(response);
  }

  Future<dynamic> delete(url) async {
    final response = await _delete(url);

    return _convertResponse(response);
  }

  dynamic _convertResponseDefault(Response response) {
    var url = response.request.url;
    var result = JsonResponseResult();
    var detailMessage = "";

    if (response.body != null && response.body != "") {
      result = JsonResponseResult.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode >= 400) {
      detailMessage =
          'Request to $url failed with status ${response.statusCode}';

      if (response.reasonPhrase != null) {
        detailMessage = '$detailMessage: ${response.reasonPhrase}';
      }

      if (response.statusCode == 401)
        throw UnauthorizedAccessException(detailMessage);

      result.success = false;
    }

    if (!result.success) {
      var message = result.message != null && result.message != ""
          ? result.message
          : "An error has occurred!";

      if (detailMessage == null || detailMessage == "") {
        detailMessage = "Request to $url failed: $message";
      }

      throw UserFriendlyException(message, detailMessage);
    }

    return result.data;
  }

  dynamic _convertResponse(Response response) {
    return this.convertResponse != null
        ? this.convertResponse(response)
        : _convertResponseDefault(response);
  }

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<Response> _sendUnstreamed(
      String method, url, Map<String, String> headers,
      [body, Encoding encoding]) async {
    var request = Request(method, _tryGetUri(url));
    headers = await _trySetDefaultHeader(body, headers);

    if (headers != null) request.headers.addAll(headers);

    if (encoding != null) request.encoding = encoding;

    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return Response.fromStream(await request.send());
  }

  /// Throws an error if [response] is not successful.
  void _checkResponseSuccess(Response response) {
    var url = response.request.url;

    if (response.statusCode >= 400) {
      var detailMessage =
          'Request to $url failed with status ${response.statusCode}';

      if (response.reasonPhrase != null) {
        detailMessage = '$detailMessage: ${response.reasonPhrase}';
      }

      if (response.statusCode == 401)
        throw UnauthorizedAccessException(detailMessage);

      throw ClientException('$detailMessage.', url);
    }
  }

  void close() {}

  Uri _tryGetUri(String url) {
    return Uri.parse(this.baseUrl + url);
  }

  Future<Map<String, String>> _trySetDefaultHeader(
      body, Map<String, String> headers) async {
    if (headers == null) {
      headers = Map<String, String>();
    }

    if (body == null || body is String) {
      headers["Content-Type"] = "application/json";
    }

    if (await appAuthService?.isAuthentication == true) {
      headers["Authorization"] = 'Bearer ' + await appAuthService.getToken();
    }

    return headers;
  }
}

abstract class EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;
  String prefix;

  EndUserServiceProxyBase({
    @required String baseUrl,
    @required this.appAuthService,
    this.prefix = "/api/v1",
  }) {
    this.client = HttpClient(
        baseUrl: baseUrl,
        prefix: this.prefix,
        appAuthService: appAuthService,
        convertResponse: convertResponseDefault);
  }

  dynamic convertResponseDefault(Response response) {
    var url = response.request.url;
    var result = EndUserJsonResponseResult();
    var detailMessage = "";

    if (response.body != null && response.body != "") {
      result = EndUserJsonResponseResult.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode >= 400) {
      detailMessage =
          'Request to $url failed with status ${response.statusCode}';

      if (response.reasonPhrase != null) {
        detailMessage = '$detailMessage: ${response.reasonPhrase}';
      }

      if (response.statusCode == 401)
        throw UnauthorizedAccessException(detailMessage);

      result.success = false;
    }

    if (!result.success) {
      var message = result.message != null && result.message != ""
          ? result.message
          : "An error has occurred!";

      if (detailMessage == null || detailMessage == "") {
        detailMessage = "Request to $url failed: $message";
      }

      throw UserFriendlyException(message, detailMessage);
    }

    return result.result;
  }
}

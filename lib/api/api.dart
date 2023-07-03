import 'dart:io';

import 'package:alarm_test/constants/api.dart';
import 'package:http/http.dart' as http;

import '../utils/sharedPref.dart';

class API extends http.BaseClient {
  http.Client _client = http.Client();
  String? jwtToken;
  Map<String, String> _headers = {};

  void _setHeader() {
    _headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $jwtToken"
    };
  }

  Future<void> initialize() async {
    jwtToken = await SharedPreferencesHelper.getString('jwtToken');
    String? name = await SharedPreferencesHelper.getString('userName');
    if (jwtToken != null) {
      _setHeader();
    }
  }

  API();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await initialize();
    var baseUrl = Uri.parse(apiRoute);
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

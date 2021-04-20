import 'dart:convert';
import 'package:http/http.dart' as http;

class Rest {
  String _token = '';
  String _endpoint = '';
  int _statusCode = 0;

  Rest(String endpoint) {
    _endpoint = endpoint;
  }

  Future<Map> get(String uri, [Map? params]) {
    return this._call('GET', uri);
  }

  Future<Map> post(String uri, [Map? params]) {
    return this._call('POST', uri, params);
  }

  Future<Map> put(String uri, [Map? params]) {
    return this._call('PUT', uri, params);
  }

  Future<Map> patch(String uri, [Map? params]) {
    return this._call('PATCH', uri, params);
  }

  Future<Map> delete(String uri, [Map? params]) {
    return this._call('DELETE', uri, params);
  }

  int get statusCode => _statusCode;

  set token(String value) {
    _token = value;
  }

  set endpoint(String value) {
    _endpoint = value;
  }

  Future<Map> _call(String method, String uri, [Map? params]) async {
    _statusCode = 0;
    var url = Uri.parse(_endpoint + uri);
    var headers = {
      "Content-Type": "application/json",
    };

    if (_token != '') {
      headers['Authorization'] = "Bearer $_token";
    }

    if (params == null) {
      params = {};
    }

    String body = json.encode(params);
    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(url, headers: headers, body: body);
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers, body: body);
        break;
      case 'PATCH':
        response = await http.patch(url, headers: headers, body: body);
        break;
      default:
        throw RestException('Invalid method: ' + method, 400);
    }

    _statusCode = response.statusCode;
    Map res = json.decode(response.body);

    if (response.statusCode > 201) {
      throw RestException(res['error'], _statusCode);
    } else {
      return res['result'];
    }
  }
}

class RestException implements Exception {
  final String message;
  final int code;
  RestException(this.message, this.code);
}

Rest rest = Rest('https://api.igaming.space');

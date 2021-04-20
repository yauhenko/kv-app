import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/counter.dart';
import '../classes/transaction.dart';
import '../classes/user.dart';

class Api {
  String _login = '';
  String _passwd = '';
  static const _endpoint = 'https://apps.redstream.by/kv/api.php';

  void logout() {
    _login = '';
    _passwd = '';
  }

  Future<User> auth(String login, String passwd) async {
    var res = await call('login', {'login': login, 'passwd': passwd});
    this._login = login;
    this._passwd = passwd;
    return User.fromJson(res);
  }

  Future<List<Counter>> getCounters(int flatId) async {
    List items = await call('counters-list', {'flat': flatId});
    List<Counter> result = [];
    items.forEach((json) {
      result.add(Counter.fromJson(json));
    });
    return result;
  }

  Future<List<Transaction>> getTransactions() async {
    List items = await call('billing-list');
    List<Transaction> result = [];
    items.forEach((json) {
      result.add(Transaction.fromJson(json));
    });
    return result;
  }

  Future<dynamic> call(String method, [Map? params]) async {
    var url = Uri.parse(_endpoint);
    var headers = {
      "Content-Type": "application/json",
    };

    if (params == null) {
      params = {};
    }

    params['method'] = method;

    if (_login != '' && _passwd != '') {
      params['login'] = _login;
      params['passwd'] = _passwd;
    }

    print(params);

    String body = json.encode(params);
    http.Response response = await http.post(url, headers: headers, body: body);

    Map res = json.decode(response.body);

    if (res['error'] != null) {
      throw ApiException(res['error'], res['code'] ?? 0);
    } else {
      return res['result'];
    }
  }

}

class ApiException implements Exception {
  final String message;
  final int code;

  ApiException(this.message, this.code);
}

Api api = Api();

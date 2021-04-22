import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../utils/api.dart';
import '../state.dart';
import '../utils/storage.dart';
import '../classes/user.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _AuthState(),
      child: _AuthForm(),
    );
  }
}

class _AuthForm extends StatelessWidget {
  Future doLogin(BuildContext context) async {
    _AuthState state = context.read<_AuthState>();

    try {
      state.loading = true;

      User user = await api.auth(state.login, state.passwd);
      context.read<AppState>().user = user;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Добро пожаловать, ' + user.name + '!'),
        backgroundColor: Colors.green,
      ));

      storage.write(key: 'login', value: state.login);
      storage.write(key: 'passwd', value: state.passwd);
    } on ApiException catch (error) {
      Vibration.vibrate(pattern: [0, 20, 100, 20]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red,
      ));
    } finally {
      state.loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _AuthState state = context.watch<_AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Войдите в свой аккаунт'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: AbsorbPointer(
            absorbing: state.loading,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Image.asset(
                      'assets/images/icon.png',
                      height: 100,
                    )),
                  ),
                  Text('Логин'),
                  TextFormField(
                    readOnly: state.loading,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'irina',
                    ),
                    onChanged: (text) {
                      state.login = text;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Пароль ${state.passwd}'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '******',
                    ),
                    readOnly: state.loading,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (text) {
                      state.passwd = text;
                    },
                  ),
                  Center(
                    child: Padding(
                      child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: state.loading
                            ? null
                            : () {
                                doLogin(context);
                              },
                        child: Text(
                          'Войти',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 20),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class _AuthState with ChangeNotifier {
  String _login = '';
  String _passwd = '';
  bool _loading = false;

  String get login => _login;

  set login(String value) {
    _login = value;
    notifyListeners();
  }

  String get passwd => _passwd;

  set passwd(String value) {
    _passwd = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:kv/api.dart';
import 'package:kv/classes.dart';
import 'package:kv/state.dart';
import 'package:kv/storage.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _AuthState(),
      child: AuthForm(),
    );
  }
}

class AuthForm extends StatelessWidget {
  Future doLogin(BuildContext context) async {
    _AuthState state = context.read<_AuthState>();

    try {
      state.loading = true;

      User user = await api.auth(state.login, state.passwd);
      context.read<AppState>().user = user;

      await storage.write(key: 'login', value: state.login);
      await storage.write(key: 'passwd', value: state.passwd);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Добро пожаловать, ' + user.name + '!'),
        backgroundColor: Colors.green,
      ));
    } on ApiException catch (error) {
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
                  Padding(
                    child: ElevatedButton(
                      onPressed: state.loading
                          ? null
                          : () {
                              doLogin(context);
                            },
                      child: Text('Войти'),
                    ),
                    padding: EdgeInsets.only(top: 20),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();
    User user = state.user!;
    Flat? flat = user.flat;
    return Scaffold(
      appBar: AppBar(
        title: Text(state.user?.name ?? ''),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Баланс: \$ ${user.balance.toString()}'),
            Text(flat != null ? '${flat.address} (\$ ${flat.price} в мес.)' : ''),
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
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

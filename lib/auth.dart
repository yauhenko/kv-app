import 'package:flutter/material.dart';
import 'package:kv/api.dart';
import 'package:kv/classes.dart';
import 'package:kv/storage.dart';

// ignore: must_be_immutable
class AuthScreen extends StatefulWidget {
  Function setUser;

  AuthScreen(this.setUser);

  @override
  _AuthScreenState createState() => _AuthScreenState(this);
}

class _AuthScreenState extends State<AuthScreen> {
  AuthScreen screen;

  _AuthScreenState(this.screen);

  String login = '';
  String passwd = '';
  bool loading = false;

  Future doLogin() async {
    try {
      setState(() {
        loading = true;
      });

      User user = await api.auth(login, passwd);

      print(user);

      await storage.write(key: 'login', value: login);
      await storage.write(key: 'passwd', value: passwd);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Добро пожаловать, ' + user.name + '!'),
        backgroundColor: Colors.green,
      ));

      this.screen.setUser(user);
    } on ApiException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Войдите в свой аккаунт'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: AbsorbPointer(
            absorbing: loading,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Логин'),
                  TextFormField(
                    readOnly: loading,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'irina',
                    ),
                    onChanged: (text) => {
                      setState(() {
                        login = text;
                      })
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Пароль $passwd'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '******',
                    ),
                    readOnly: loading,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (text) => {
                      setState(() {
                        passwd = text;
                      })
                    },
                  ),
                  Padding(
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              doLogin();
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

// ignore: must_be_immutable
class SecondScreen extends StatelessWidget {
  User user;
  Function exit;

  SecondScreen(this.user, this.exit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            this.exit();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}

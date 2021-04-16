import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:kv/classes.dart';

import 'api.dart';
import 'auth.dart';
import 'storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool ready = false;
  String login = '';
  String passwd = '';
  String fcmToken = '';
  User? user;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  exit() {
    api.logout();
    storage.deleteAll();
    setState(() {
      user = null;
      login = '';
      passwd = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Сессия закрыта'),
    ));
  }

  init() async {

    Firebase.initializeApp().then((app) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.getToken().then((token) {
        fcmToken = token ?? '';
        print('fcm: $token');
      });
    });

    login = await storage.read(key: 'login') ?? '';
    passwd = await storage.read(key: 'passwd') ?? '';

    print('login: ' + login);
    print('passwd: ' + passwd);

    try {
      User user = await api.auth(login, passwd);
      setState(() {
        this.user = user;
      });
    } catch (_) {
      api.logout();
      storage.delete(key: 'login');
      storage.delete(key: 'passwd');
    } finally {
      setState(() {
        ready = true;
      });
    }
  }

  void setUser(User? user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Квартирант',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ready
          ? (user == null ? AuthScreen(setUser) : SecondScreen(user!, exit))
          : Text('Loading...'),
    );
  }
}

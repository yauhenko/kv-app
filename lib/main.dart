import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:kv/state.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'auth.dart';
import 'storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppState()),
    ],
    child: App(),
  ));
}

bool isInit = false;

class App extends StatelessWidget {

  // exit() {
  //   api.logout();
  //   storage.deleteAll();
  //   setState(() {
  //     user = null;
  //     login = '';
  //     passwd = '';
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text('Сессия закрыта'),
  //   ));
  // }

  init(BuildContext context) async {
    if(isInit) return;
    isInit = true;
    print('init');

    AppState state =  context.read<AppState>();

    Firebase.initializeApp().then((app) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.getToken().then((token) {
        state.fcmToken = token ?? '';
        print('fcm: $token');
      });
    });

    state.login = await storage.read(key: 'login') ?? '';
    state.passwd = await storage.read(key: 'passwd') ?? '';

    try {
      state.user = await api.auth(state.login, state.passwd);
    } catch (_) {
     state.logout();
    } finally {
     state.ready  = true;
    }

  }

  @override
  Widget build(BuildContext context) {
    this.init(context);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    AppState state = context.watch<AppState>();

    return MaterialApp(
      title: 'Квартирант',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: state.ready ? (state.user == null ? AuthScreen() : SecondScreen()) : Text('Loading...'),
      // home: Text('Loading...'),
    );
  }
}

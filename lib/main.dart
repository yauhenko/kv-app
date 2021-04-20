import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:kv/screens/home.dart';
import 'package:kv/screens/submit.dart';
import 'package:kv/state.dart';
import 'package:provider/provider.dart';

import 'utils/api.dart';
import 'screens/auth.dart';
import 'utils/storage.dart';

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
  init(BuildContext context) async {
    // return;
    if (isInit) return;
    isInit = true;
    print('init');

    AppState state = context.read<AppState>();

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
      state.ready = true;
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
      home: state.ready ? (state.user == null ? AuthScreen() : HomeScreen()) : SplashScreen(),
      routes: {
        '/submit': (BuildContext context) => SubmitScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 50, right: 50, bottom: 50),
            child: Image.asset(
              'assets/images/icon.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Text(
              'Загрузка...',
              style: TextStyle(fontSize: 30, color: Colors.black54),
            ),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

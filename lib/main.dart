import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((token) => {
      print(token),
  });
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'Квартирант',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Квартирант'),
          ),
          body: WebView(
            initialUrl: 'https://kv.yabx.net/',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}


// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: 'https://showcase.codethislab.com/games/slot_the_fruits/',
//       javascriptMode: JavascriptMode.unrestricted,
//     );
//   }
// }

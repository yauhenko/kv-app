import 'package:flutter/material.dart';
import 'package:kv/classes/counter.dart';
import 'package:kv/state.dart';
import 'package:provider/provider.dart';

bool isInit = false;

class SubmitScreen extends StatelessWidget {
  void init(BuildContext context) async {
    if (isInit) return;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    AppState state = context.watch<AppState>();
    //User user = state.user!;

    return ChangeNotifierProvider(
      create: (_) => _State(),
      child: _Form(),
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Счетчики'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Блааа'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class _State with ChangeNotifier {
  bool _loading = true;
  List<Counter> _counters = [];

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Counter> get counters => _counters;

  set counters(List<Counter> value) {
    _counters = value;
    notifyListeners();
  }
}

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../classes/flat.dart';
import '../classes/user.dart';
import '../state.dart';

class HomeScreen extends StatelessWidget {
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Сессия закрыта'),
                ));
                context.read<AppState>().logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Подать счетчики',
        onPressed: () {
          Navigator.pushNamed(context, '/submit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

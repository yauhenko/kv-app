import 'utils/api.dart';
import 'classes/user.dart';

void main() async {
  try {
    User user = await api.auth("irina", "2873");

    //var tr = await api.getTransactions();
    if(user.flat != null) {
      var tr = await api.getCounters(user.flat!.id);
      print(tr);
    }

  } on ApiException catch (e) {
    print('Ошибка: ' + e.message);
  }
}

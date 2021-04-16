// import 'rest.dart';
//
// class _Users {
//
//   Future<User> getCurrentUser() async {
//     return User.fromJson(await rest.get('/users/current'));
//   }
//
// }
//
// class API {
//   _Users users;
//   API({
//     required this.users,
//   });
// }
//
// final api = API(
//     users: _Users(),
// );
//
//
// class User {
//   int id;
//   String email;
//   String? name;
//   String role;
//   Upload? avatar;
//
//   User(this.id, this.email, this.role, {this.name, this.avatar});
//
//   factory User.fromJson(dynamic json) {
//     return User(
//       json['id'],
//       json['email'],
//       json['role'],
//       avatar: json['avatar'] != null ? Upload.fromJson(json['avatar']) : null,
//       name: json['name'],
//     );
//   }
// }
//
// class Upload {
//   String id;
//   String url;
//   Map? extra;
//
//   Upload(this.id, this.url, [this.extra]);
//
//   factory Upload.fromJson(dynamic json) {
//     return Upload(
//       json['id'] as String,
//       json['url'] as String,
//       json['extra'] as Map?,
//     );
//   }
// }

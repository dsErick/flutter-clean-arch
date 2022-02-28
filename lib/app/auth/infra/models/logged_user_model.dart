import 'dart:convert';

import 'package:clean_architecture/app/auth/domain/entities/logged_user_entity.dart';

class LoggedUserModel extends LoggedUserEntity {
  const LoggedUserModel({ required String name, required String email }) : super(name: name, email: email);

  factory LoggedUserModel.fromMap(Map<String, dynamic> map) {
    return LoggedUserModel(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  factory LoggedUserModel.fromJson(String json) => LoggedUserModel.fromMap(jsonDecode(json));
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:perpustakaan/models/user_data_model.dart';

Future<List<UserData>> fetchData() async {
  String jsonString = await rootBundle.loadString('data.json');
  List<dynamic> jsonList = json.decode(jsonString);

  List<UserData> userList = jsonList.map((json) => UserData.fromJson(json)).toList();

  return userList;
}
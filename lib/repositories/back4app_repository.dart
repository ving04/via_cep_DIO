// ignore_for_file: unused_local_variable
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep/models/back4app_model.dart';

class Back4appRepository {
  final _headers = {
    'X-Parse-Application-Id': '4r3r5jJ69g6OJneUt1JigUs5SaCzm0G1py0HQSfg',
    'X-Parse-REST-API-Key': 'qbonHxOze3gMuAtgzNGeQVuDuuPYcW2YC38Ek4UY',
    'Content-Type': 'application/json'
  };

  final _baseUrl = 'https://parseapi.back4app.com/classes';

  Future<dynamic> addCep(dynamic body) async {
    var response = await http.post(
      Uri.parse('$_baseUrl/via_cep_DIO'),
      body: jsonEncode(body),
      headers: _headers,
    );
    return response.body;
  }

  Future<Back4appModel> getDbCep() async {
    var response = await http.get(
      Uri.parse('$_baseUrl/via_cep_DIO'),
      headers: _headers,
    );
    final json = jsonDecode(response.body);
    final result = json['results'] as List;
    return Back4appModel.fromJson(json);
  }

  Future<void> deleteById(String id) async {
    var response = await http.delete(
      Uri.parse('$_baseUrl/via_cep_DIO/$id'),
      headers: _headers,
    );
  }
}

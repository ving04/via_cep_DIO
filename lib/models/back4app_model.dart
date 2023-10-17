import 'dart:convert';

Back4appModel back4AppmodelFromJson(String str) =>
    Back4appModel.fromJson(json.decode(str));

String back4AppmodelToJson(Back4appModel data) => json.encode(data.toJson());

class Back4appModel {
  List<AddressModel>? results;

  Back4appModel({
    this.results,
  });

  factory Back4appModel.fromJson(Map<String, dynamic> json) => Back4appModel(
        results: List<AddressModel>.from(
            json['results'].map((x) => AddressModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results != null
            ? List<dynamic>.from(results!.map((x) => x.toJson()))
            : [],
      };
}

class AddressModel {
  String? objectId;
  String cep;
  String logradouro;
  String localidade;
  String uf;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    this.objectId,
    required this.cep,
    required this.logradouro,
    required this.localidade,
    required this.uf,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        objectId: json['objectId'],
        cep: json['cep'],
        logradouro: json['logradouro'],
        localidade: json['localidade'],
        uf: json['uf'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'localidade': localidade,
        'uf': uf,
      };
}

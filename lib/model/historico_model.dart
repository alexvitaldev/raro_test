import 'package:raro_test/database/entity.dart';

class HistoricoModel extends Entity{

  int? id;
  String? descricaoVaga;
  String? placaVeiculo;
  DateTime entrada;
  DateTime? saida;

  HistoricoModel({required this.entrada, this.saida, this.id, this.descricaoVaga, this.placaVeiculo,});


  // Converter um objeto Vaga em um Map. Útil para inserções no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricaoVaga': descricaoVaga,
      'placaVeiculo': placaVeiculo,
      'entrada': entrada.toIso8601String(),
      'saida': saida != null ? saida!.toIso8601String() : null,
    };
  }

  // Criar um objeto Vaga a partir de um Map.
  factory HistoricoModel.fromMap(Map<String, dynamic> map) {
    HistoricoModel historicoModel = HistoricoModel(
        id: map['id'],
        descricaoVaga: map['descricaoVaga'],
        placaVeiculo: map['placaVeiculo'],
      entrada: DateTime.parse(map['entrada']),
      saida: map['saida'] != null ? DateTime.parse(map['saida']) : null,
    );

    return historicoModel;
  }

  @override
  String toString() {
    return 'HistoricoModel{id: $id, descricaoVaga: $descricaoVaga, placaVeiculo: $placaVeiculo, entrada: $entrada, saida: $saida}';
  }
}
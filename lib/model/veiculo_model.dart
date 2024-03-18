import 'package:raro_test/database/entity.dart';

class VeiculoModel extends Entity{

  int? id; // Identificador único para o veículo (opcional para novos veículos)
  String placa;
  DateTime entrada;
  DateTime? saida; // Opcional, pois será nulo quando o veículo estiver no estacionamento

  VeiculoModel({this.id, required this.placa, required this.entrada, this.saida});

  // Converter um objeto Veiculo em um Map.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'placa': placa,
      'entrada': entrada.toIso8601String(),
    };

    saida != null ? map['saida'] = saida!.toIso8601String() : null;

    return map;
  }

  // Criar um objeto Veiculo a partir de um Map. Útil para leituras do banco de dados.
  factory VeiculoModel.fromMap(Map<String, dynamic> map) {
    return VeiculoModel(
      id: map['id'],
      placa: map['placa'],
      entrada: DateTime.parse(map['entrada']),
      saida: map['saida'] != null ? DateTime.parse(map['saida']) : null,
    );
  }

  @override
  String toString() {
    return 'VeiculoModel{id: $id, placa: $placa, entrada: $entrada, saida: $saida}';
  }
}
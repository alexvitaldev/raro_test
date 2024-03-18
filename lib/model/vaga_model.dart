import 'package:raro_test/database/entity.dart';
import 'package:raro_test/model/veiculo_model.dart';

class VagaModel extends Entity{
  int? id; // Identificador único para a vaga
  String description;
  int? idVeiculo;
  VeiculoModel? veiculo;

  VagaModel({required this.description, this.id, this.idVeiculo, this.veiculo});

  // Converter um objeto Vaga em um Map. Útil para inserções no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'idVeiculo': idVeiculo,
    };
  }

  // Criar um objeto Vaga a partir de um Map.
  factory VagaModel.fromMap(Map<String, dynamic> map) {
     VagaModel vagaModel = VagaModel(
      id: map['id'],
      description: map['description'],
      idVeiculo: map['idVeiculo']
    );

     return vagaModel;
  }

  @override
  String toString() {
    return 'VagaModel{id: $id, description: $description, idVeiculo: $idVeiculo, veiculo: $veiculo}';
  }
}

import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:raro_test/database/base_dao.dart';
import 'package:raro_test/database/db_helper.dart';

// Data Access Object
class VeiculoDao extends BaseDAO<VeiculoModel>{

  Future<Database> get db => DatabaseHelper.getInstance().db;

  Future<int> save(VeiculoModel veiculo) async {
    var dbClient = await db;
    var id = await dbClient.insert("veiculos", veiculo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> update(VeiculoModel veiculo) async {
    var dbClient = await db;
    int updateCount = await dbClient.rawUpdate('''
    UPDATE veiculos 
    SET placa = ?, entrada = ?, saida = ?
    WHERE id = ?
    ''',
        [veiculo.placa, veiculo.entrada.toString(), veiculo.saida.toString(), veiculo.id]);

    print("updateCount: $updateCount");
    return updateCount;

  }

  Future<List<VeiculoModel>> findAll() async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from veiculos');

    final veiculos = list.map<VeiculoModel>((json) => VeiculoModel.fromMap(json)).toList();

    return veiculos;
  }

  Future<List<VeiculoModel>> findAllByTipo(String tipo) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from veiculos where tipo =? ',[tipo]);

    final veiculos = list.map<VeiculoModel>((json) => VeiculoModel.fromMap(json)).toList();

    return veiculos;
  }

  Future<VeiculoModel?> findById(int id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from veiculos where id = ?', [id]);

    if (list.length > 0) {
      return new VeiculoModel.fromMap(list.first);
    }

    return null;
  }

  Future<int?> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from veiculos');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from veiculos where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from veiculos');
  }

  @override
  VeiculoModel fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

}

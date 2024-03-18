
import 'package:raro_test/model/vaga_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:raro_test/database/base_dao.dart';
import 'package:raro_test/database/db_helper.dart';

// Data Access Object
class VagaDao extends BaseDAO<VagaModel>{

  Future<Database> get db => DatabaseHelper.getInstance().db;

  Future<int> save(VagaModel vaga) async {
    var dbClient = await db;
    var id = await dbClient.insert("vagas", vaga.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> update(VagaModel vaga) async {
    var dbClient = await db;
    int updateCount = await dbClient.rawUpdate('''
    UPDATE vagas 
    SET description = ?, idVeiculo = ?
    WHERE id = ?
    ''',
        [vaga.description, vaga.idVeiculo, vaga.id]);

    print("updateCount: $updateCount");
    return updateCount;

  }

  Future<List<VagaModel>> findAll() async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from vagas');

    final vagas = list.map<VagaModel>((json) => VagaModel.fromMap(json)).toList();

    return vagas;
  }

  Future<List<VagaModel>> findAllByTipo(String tipo) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from vagas where tipo =? ',[tipo]);

    final vagas = list.map<VagaModel>((json) => VagaModel.fromMap(json)).toList();

    return vagas;
  }

  Future<VagaModel?> findById(int id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from vagas where id = ?', [id]);

    if (list.length > 0) {
      return new VagaModel.fromMap(list.first);
    }

    return null;
  }

  Future<int?> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from vagas');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from vagas where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from vagas');
  }

  @override
  VagaModel fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

}

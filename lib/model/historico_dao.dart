
import 'package:raro_test/model/historico_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:raro_test/database/base_dao.dart';
import 'package:raro_test/database/db_helper.dart';

// Data Access Object
class HistoricoDao extends BaseDAO<HistoricoModel>{

  Future<Database> get db => DatabaseHelper.getInstance().db;

  Future<int> save(HistoricoModel historico) async {
    var dbClient = await db;
    var id = await dbClient.insert("historicos", historico.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    //print('id: $id');
    return id;
  }

  Future<int> update(HistoricoModel historico) async {
    var dbClient = await db;
    int updateCount = await dbClient.rawUpdate('''
    UPDATE historicos 
    SET descricaoVaga = ?, placaVeiculo = ?, entrada = ?, saida = ?
    WHERE id = ?
    ''',
        [historico.descricaoVaga, historico.placaVeiculo, historico.entrada.toString(), historico.saida.toString(), historico.id]);

    print("updateCount: $updateCount");
    return updateCount;

  }

  Future<List<HistoricoModel>> findAll({desc = true}) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery(desc
        ? 'SELECT * FROM historicos ORDER BY id DESC'
        : 'SELECT * FROM historicos'
    );

    final historicos = list.map<HistoricoModel>((json) => HistoricoModel.fromMap(json)).toList();

    return historicos;
  }

  Future<List<HistoricoModel>> findAllByTipo(String tipo) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from historicos where tipo =? ',[tipo]);

    final historicos = list.map<HistoricoModel>((json) => HistoricoModel.fromMap(json)).toList();

    return historicos;
  }

  Future<HistoricoModel?> findById(int id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from historicos where id = ?', [id]);

    if (list.length > 0) {
      return new HistoricoModel.fromMap(list.first);
    }

    return null;
  }

  Future<int?> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from historicos');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from historicos where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from historicos');
  }

  @override
  HistoricoModel fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

}

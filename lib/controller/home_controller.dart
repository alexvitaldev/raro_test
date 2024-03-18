import 'package:mobx/mobx.dart';
import 'package:raro_test/model/historico_dao.dart';
import 'package:raro_test/model/historico_model.dart';
import 'package:raro_test/model/vaga_dao.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_dao.dart';
import 'package:raro_test/model/veiculo_model.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  late final VagaDao vagaDao;
  late final VeiculoDao veiculoDao;
  late final HistoricoDao historicoDao;

  _HomeController({VagaDao? vagaDao, VeiculoDao? veiculoDao, HistoricoDao? historicoDao}) {
    this.vagaDao = vagaDao ?? VagaDao();
    this.veiculoDao = veiculoDao ?? VeiculoDao();
    this.historicoDao = historicoDao ?? HistoricoDao();
  }

  @observable
  ObservableList<VagaModel> vagaList = ObservableList();

  @observable
  ObservableList<VeiculoModel> veiculoList = ObservableList();

  @observable
  ObservableList<HistoricoModel> listaHistorico = ObservableList();

  @observable
  bool loading = false;

  @observable
  VagaModel? vagaSelecionada;

  Future init() async{
    vagaList.clear();
    await _getVagasLocal();
    await getHistoricos();
  }

  Future _getVagasLocal() async{
    vagaList.clear();
    List<VagaModel> listVagas = await vagaDao.findAll();

    for(VagaModel vaga in listVagas){
      if(vaga.idVeiculo != null){
        vaga.veiculo = await getVeiculo(vaga.idVeiculo!);
      }
      vagaList.add(vaga);
    }
  }


  @action
  Future<void> createVaga(VagaModel vaga) async {
    loading = true;
    await vagaDao.save(vaga);
    await _getVagasLocal();
  }

  @action
  updateVaga(VagaModel vaga) async {
    loading = true;
    await vagaDao.update(vaga);
    await _getVagasLocal();
    vagaSelecionada = vaga;
  }

  @action
  deleteVaga(VagaModel vaga) async {
    loading = true;
    vagaDao.delete(vaga.id!);
    _getVagasLocal();
  }

  @action
  Future<int> createVeiculo(VeiculoModel veiculo, VagaModel vaga) async {
    loading = true;
    vagaSelecionada = vaga;

    HistoricoModel historicoModel = HistoricoModel(entrada: veiculo.entrada);
    historicoModel.placaVeiculo = veiculo.placa;
    historicoModel.descricaoVaga = vaga.description;
    historicoModel.saida = null;
    await createHistorico(historicoModel);
    return await veiculoDao.save(veiculo);
  }

  @action
  Future<VeiculoModel?> getVeiculo(int idVeiculo) async {
    loading = true;
    return await veiculoDao.findById(idVeiculo);
  }

  @action
  Future<void> saidaVeiculo(VeiculoModel veiculo, VagaModel vaga) async {
    loading = true;
    vaga.idVeiculo = null;

    HistoricoModel historico = HistoricoModel(entrada: veiculo.entrada, saida: veiculo.saida ?? DateTime.now());
    historico.placaVeiculo = veiculo.placa;
    historico.descricaoVaga = vaga.description;

    await createHistorico(historico, get: false);
    await vagaDao.update(vaga);
    await veiculoDao.delete(veiculo.id!);

    await _getVagasLocal();
    await getHistoricos();
  }

  @action
  Future<void> getHistoricos() async {
    loading = true;
    listaHistorico.clear();

    List<HistoricoModel> list = await historicoDao.findAll();

    for (HistoricoModel historico in list){
      listaHistorico.add(historico);
    }

  }

  @action
  Future<void> createHistorico(HistoricoModel historicoModel, {get = true}) async {
    loading = true;
    await historicoDao.save(historicoModel);
    if(get) await getHistoricos();
  }

  @action
  Future<void> deleteHistorico(HistoricoModel historico) async {
    loading = true;
    await historicoDao.delete(historico.id!);
    await getHistoricos();
  }

  @action
  Future<void> clearHistorico() async {
    loading = true;

    await historicoDao.deleteAll();
    await getHistoricos();

  }
}
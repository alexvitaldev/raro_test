// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeController, Store {
  late final _$vagaListAtom =
      Atom(name: '_HomeController.vagaList', context: context);

  @override
  ObservableList<VagaModel> get vagaList {
    _$vagaListAtom.reportRead();
    return super.vagaList;
  }

  @override
  set vagaList(ObservableList<VagaModel> value) {
    _$vagaListAtom.reportWrite(value, super.vagaList, () {
      super.vagaList = value;
    });
  }

  late final _$veiculoListAtom =
      Atom(name: '_HomeController.veiculoList', context: context);

  @override
  ObservableList<VeiculoModel> get veiculoList {
    _$veiculoListAtom.reportRead();
    return super.veiculoList;
  }

  @override
  set veiculoList(ObservableList<VeiculoModel> value) {
    _$veiculoListAtom.reportWrite(value, super.veiculoList, () {
      super.veiculoList = value;
    });
  }

  late final _$listaHistoricoAtom =
      Atom(name: '_HomeController.listaHistorico', context: context);

  @override
  ObservableList<HistoricoModel> get listaHistorico {
    _$listaHistoricoAtom.reportRead();
    return super.listaHistorico;
  }

  @override
  set listaHistorico(ObservableList<HistoricoModel> value) {
    _$listaHistoricoAtom.reportWrite(value, super.listaHistorico, () {
      super.listaHistorico = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_HomeController.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$vagaSelecionadaAtom =
      Atom(name: '_HomeController.vagaSelecionada', context: context);

  @override
  VagaModel? get vagaSelecionada {
    _$vagaSelecionadaAtom.reportRead();
    return super.vagaSelecionada;
  }

  @override
  set vagaSelecionada(VagaModel? value) {
    _$vagaSelecionadaAtom.reportWrite(value, super.vagaSelecionada, () {
      super.vagaSelecionada = value;
    });
  }

  late final _$createVagaAsyncAction =
      AsyncAction('_HomeController.createVaga', context: context);

  @override
  Future<void> createVaga(VagaModel vaga) {
    return _$createVagaAsyncAction.run(() => super.createVaga(vaga));
  }

  late final _$updateVagaAsyncAction =
      AsyncAction('_HomeController.updateVaga', context: context);

  @override
  Future updateVaga(VagaModel vaga) {
    return _$updateVagaAsyncAction.run(() => super.updateVaga(vaga));
  }

  late final _$deleteVagaAsyncAction =
      AsyncAction('_HomeController.deleteVaga', context: context);

  @override
  Future deleteVaga(VagaModel vaga) {
    return _$deleteVagaAsyncAction.run(() => super.deleteVaga(vaga));
  }

  late final _$createVeiculoAsyncAction =
      AsyncAction('_HomeController.createVeiculo', context: context);

  @override
  Future<int> createVeiculo(VeiculoModel veiculo, VagaModel vaga) {
    return _$createVeiculoAsyncAction
        .run(() => super.createVeiculo(veiculo, vaga));
  }

  late final _$getVeiculoAsyncAction =
      AsyncAction('_HomeController.getVeiculo', context: context);

  @override
  Future<VeiculoModel?> getVeiculo(int idVeiculo) {
    return _$getVeiculoAsyncAction.run(() => super.getVeiculo(idVeiculo));
  }

  late final _$saidaVeiculoAsyncAction =
      AsyncAction('_HomeController.saidaVeiculo', context: context);

  @override
  Future<void> saidaVeiculo(VeiculoModel veiculo, VagaModel vaga) {
    return _$saidaVeiculoAsyncAction
        .run(() => super.saidaVeiculo(veiculo, vaga));
  }

  late final _$getHistoricosAsyncAction =
      AsyncAction('_HomeController.getHistoricos', context: context);

  @override
  Future<void> getHistoricos() {
    return _$getHistoricosAsyncAction.run(() => super.getHistoricos());
  }

  late final _$createHistoricoAsyncAction =
      AsyncAction('_HomeController.createHistorico', context: context);

  @override
  Future<void> createHistorico(HistoricoModel historicoModel,
      {dynamic get = true}) {
    return _$createHistoricoAsyncAction
        .run(() => super.createHistorico(historicoModel, get: get));
  }

  late final _$deleteHistoricoAsyncAction =
      AsyncAction('_HomeController.deleteHistorico', context: context);

  @override
  Future<void> deleteHistorico(HistoricoModel historico) {
    return _$deleteHistoricoAsyncAction
        .run(() => super.deleteHistorico(historico));
  }

  late final _$clearHistoricoAsyncAction =
      AsyncAction('_HomeController.clearHistorico', context: context);

  @override
  Future<void> clearHistorico() {
    return _$clearHistoricoAsyncAction.run(() => super.clearHistorico());
  }

  @override
  String toString() {
    return '''
vagaList: ${vagaList},
veiculoList: ${veiculoList},
listaHistorico: ${listaHistorico},
loading: ${loading},
vagaSelecionada: ${vagaSelecionada}
    ''';
  }
}

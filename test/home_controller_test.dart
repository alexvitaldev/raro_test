import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'mocks.mocks.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:raro_test/model/historico_model.dart';

void main() {
  group('HomeController Tests', () {
    late MockVagaDao mockVagaDao;
    late MockVeiculoDao mockVeiculoDao;
    late MockHistoricoDao mockHistoricoDao;
    late HomeController homeController;

    setUp(() {
      // Inicialize os mocks e o HomeController antes de cada teste
      mockVagaDao = MockVagaDao();
      mockVeiculoDao = MockVeiculoDao();
      mockHistoricoDao = MockHistoricoDao();
      homeController = HomeController(vagaDao: mockVagaDao, veiculoDao: mockVeiculoDao, historicoDao: mockHistoricoDao);
    });

    test('init() should load vagas and historicos', () async {
      // Configuração dos mocks para retornar listas vazias
      when(mockVagaDao.findAll()).thenAnswer((_) async => []);
      when(mockHistoricoDao.findAll()).thenAnswer((_) async => []);

      await homeController.init();

      // Verifica se os métodos dos DAOs foram chamados
      verify(mockVagaDao.findAll()).called(1);
      verify(mockHistoricoDao.findAll()).called(1);
      // Verifica se as listas no controller estão vazias conforme esperado
      expect(homeController.vagaList.isEmpty, true);
      expect(homeController.listaHistorico.isEmpty, true);
    });

    test('createVaga() should add a vaga', () async {
      VagaModel testVaga = VagaModel(id: 1, description: "Vaga Teste");
      // Preparando a resposta do DAO para save
      when(mockVagaDao.save(testVaga)).thenAnswer((_) async => 1);
      // Adicionando stub para findAll para evitar MissingStubError
      // Retornando uma lista contendo a testVaga
      when(mockVagaDao.findAll()).thenAnswer((_) async => [testVaga]);

      await homeController.createVaga(testVaga);

      // Verificando se o save foi chamado
      verify(mockVagaDao.save(testVaga)).called(1);
      // Verificando se o findAll foi chamado dentro de _getVagasLocal
      verify(mockVagaDao.findAll()).called(1);

      // Verificando se a lista de vagas contém a vaga criada
      expect(homeController.vagaList.any((vaga) => vaga.id == testVaga.id && vaga.description == testVaga.description), isTrue);
    });

    test('updateVaga() should update a vaga and contain the updated vaga in vagaList', () async {
      VagaModel testVaga = VagaModel(id: 1, description: "Vaga Atualizada");
      // Preparando a resposta do DAO para update
      when(mockVagaDao.update(testVaga)).thenAnswer((_) async => Future.value(1));
      // Simulando o comportamento esperado de findAll após a atualização
      when(mockVagaDao.findAll()).thenAnswer((_) async => [testVaga]);

      // Garantindo que a lista inicial está vazia para o teste
      homeController.vagaList.clear();

      await homeController.updateVaga(testVaga);

      //Verifica se update e findAll foram chamados exatamente uma vez
      verify(mockVagaDao.update(testVaga)).called(1);
      verify(mockVagaDao.findAll()).called(1);

      // Verificando se a lista de vagas contém a vaga atualizada
      expect(homeController.vagaList.any((vaga) => vaga.id == testVaga.id && vaga.description == testVaga.description), isTrue);
    });

    test('deleteVaga() should delete a vaga and remove it from vagaList', () async {
      VagaModel testVaga = VagaModel(id: 1, description: "Vaga para Deletar");

      // Preparando a resposta do DAO para delete
      when(mockVagaDao.delete(testVaga.id)).thenAnswer((_) async => Future.value(1));

      // Simulando o comportamento esperado de findAll após deletar
      // Considerando que a vaga foi deletada, findAll não deve retornar a vaga deletada
      when(mockVagaDao.findAll()).thenAnswer((_) async => []);

      // Inicializando a vagaList com a vaga que será deletada, simulando o estado antes da deleção
      homeController.vagaList.clear(); // Garantindo que a lista esteja vazia antes do teste
      homeController.vagaList.add(testVaga); // Adicionando a vaga que será deletada

      await homeController.deleteVaga(testVaga);

      // Verifica se delete e findAll foram chamados exatamente uma vez
      verify(mockVagaDao.delete(testVaga.id)).called(1);
      verify(mockVagaDao.findAll()).called(1);

      // Verificando se a lista de vagas não contém a vaga deletada
      expect(homeController.vagaList.any((vaga) => vaga.id == testVaga.id), isFalse);
    });


    test('createVeiculo() should add a veiculo', () async {
      VeiculoModel testVeiculo = VeiculoModel(id: 1, placa: "Veiculo Teste", entrada: DateTime.now());
      VagaModel testVaga = VagaModel(id: 1, description: "Vaga para Deletar");

      // Preparando a resposta do DAO para save do Veiculo
      when(mockVeiculoDao.save(testVeiculo)).thenAnswer((_) async => 1);

      // Preparando a resposta do DAO para save do Historico
      when(mockHistoricoDao.save(any)).thenAnswer((_) async => 1);

      // Simulando o comportamento esperado de findAll após a criação do veículo
      when(mockVeiculoDao.findAll()).thenAnswer((_) async => [testVeiculo]);

      // Adicionando stub para findAll do HistoricoDao
      // Ajuste conforme a estrutura exata dos objetos HistoricoModel esperados na sua implementação
      when(mockHistoricoDao.findAll(desc: anyNamed('desc'))).thenAnswer((_) async => []);

      await homeController.createVeiculo(testVeiculo, testVaga);

      // Verificações do save e findAll para Veiculo e Historico
      verify(mockHistoricoDao.save(any)).called(1);
      verify(mockVeiculoDao.save(testVeiculo)).called(1);
      verify(mockHistoricoDao.findAll(desc: anyNamed('desc'))).called(1);
    });

    test('getVeiculo() should return a VeiculoModel when found', () async {
      final int testVeiculoId = 1;
      final VeiculoModel testVeiculo = VeiculoModel(id: testVeiculoId, placa: "ABC-1234", entrada: DateTime.now());

      // Mocking the findById method to return testVeiculo
      when(mockVeiculoDao.findById(testVeiculoId)).thenAnswer((_) async => testVeiculo);

      final result = await homeController.getVeiculo(testVeiculoId);

      expect(result, isNotNull);
      expect(result!.id, equals(testVeiculo.id));
      expect(result.placa, equals(testVeiculo.placa));

      verify(mockVeiculoDao.findById(testVeiculoId)).called(1);
    });

    test('saidaVeiculo() should update vaga, create historico, delete veiculo, and refresh lists', () async {
      final VeiculoModel testVeiculo = VeiculoModel(id: 1, placa: "ABC-1234", entrada: DateTime.now());
      final VagaModel testVaga = VagaModel(id: 1, description: "Vaga Teste");
      final DateTime saida = DateTime.now();

      final HistoricoModel expectedHistorico = HistoricoModel(
        id: 1,
        entrada: testVeiculo.entrada,
        saida: saida,
        descricaoVaga: testVaga.description,
        placaVeiculo: testVeiculo.placa
      );

      // Stubbing the necessary methods
      when(mockVagaDao.update(any)).thenAnswer((_) async => 1);
      when(mockVeiculoDao.delete(any)).thenAnswer((_) async => 1);
      when(mockHistoricoDao.save(any)).thenAnswer((_) async => 1);

      when(mockHistoricoDao.findAll(desc: true)).thenAnswer((_) async => [expectedHistorico]);
      // Stubbing findAll() for VagaDao
      when(mockVagaDao.findAll()).thenAnswer((_) async => [testVaga]);

      await homeController.saidaVeiculo(testVeiculo, testVaga);

      // Verify each method was called with the expected arguments
      verify(mockVagaDao.update(testVaga)).called(1);
      verify(mockVeiculoDao.delete(testVeiculo.id!)).called(1);
      verify(mockHistoricoDao.save(any)).called(1);
      // Verificar se o findAll retorna exatamente o que esperamos
      final historicos = await mockHistoricoDao.findAll(desc: true);
      expect(historicos, contains(expectedHistorico));
      verify(mockHistoricoDao.findAll(desc: true)).called(2);

      // Verifying findAll() call on VagaDao
      verify(mockVagaDao.findAll()).called(1);
    });

    test('createHistorico() should save a historico and optionally refresh the list', () async {
      final mockHistoricoDao = MockHistoricoDao();
      final homeController = HomeController(historicoDao: mockHistoricoDao);

      final HistoricoModel newHistorico = HistoricoModel(
          id: 1,
          entrada: DateTime.now(),
          placaVeiculo: 'DEF-5678',
          descricaoVaga: 'Vaga 1'
      );

      // Configuração do mock para save
      when(mockHistoricoDao.save(newHistorico)).thenAnswer((_) async => 1);

      // Configuração do mock para findAll
      // Isso simula o retorno de uma lista de históricos contendo o novo histórico criado,
      // indicando que a lista foi atualizada.
      when(mockHistoricoDao.findAll(desc: true)).thenAnswer((_) async => [newHistorico]);

      // Executando o método sob teste
      await homeController.createHistorico(newHistorico);

      // Verificações
      verify(mockHistoricoDao.save(newHistorico)).called(1); // Verifica se save foi chamado.

      // Verifica se a lista contem o novo histórico:
      expect(homeController.listaHistorico, contains(newHistorico));
    });


    test('getHistoricos() should fetch historicos and update listaHistorico', () async {
      // Setup mocks
      final mockHistoricoDao = MockHistoricoDao();
      final homeController = HomeController(historicoDao: mockHistoricoDao);

      final List<HistoricoModel> mockHistoricos = [
        HistoricoModel(id: 1, entrada: DateTime.now(), placaVeiculo: 'ABC-1234'),
        // Adicione mais instâncias conforme necessário
      ];

      // Definindo o comportamento esperado do mock
      when(mockHistoricoDao.findAll()).thenAnswer((_) async => mockHistoricos);

      // Executando o método sob teste
      await homeController.getHistoricos();

      // Verificações
      expect(homeController.listaHistorico, equals(mockHistoricos));
      verify(mockHistoricoDao.findAll()).called(1);
    });

    test('deleteHistorico() should remove a historico and refresh the list', () async {
      final mockHistoricoDao = MockHistoricoDao();
      final homeController = HomeController(historicoDao: mockHistoricoDao);

      final HistoricoModel historicoToRemove = HistoricoModel(id: 1, entrada: DateTime.now());

      // Caso tenha mais históricos para simular uma lista (que exclui o removido)
      final List<HistoricoModel> simulacaoListaAposRemocao = [
        // Adicionar outros históricos, excluindo o `historicoToRemove`
      ];

      // Stub do método findAll() para retornar uma lista simulada de históricos,
      // excluindo o pra remover.
      when(mockHistoricoDao.findAll()).thenAnswer((_) async => simulacaoListaAposRemocao);

      // Configuração do mock para o método delete
      when(mockHistoricoDao.delete(historicoToRemove.id!)).thenAnswer((_) async => 1);

      // Executando o método sob teste
      await homeController.deleteHistorico(historicoToRemove);

      // Verificações
      verify(mockHistoricoDao.delete(historicoToRemove.id!)).called(1); // Verifica se delete foi chamado.
      verify(mockHistoricoDao.findAll()).called(1); // Verifica se findAll foi chamado para atualizar a lista após a remoção.

      // Verifica se a lista de históricos atualizada não contém o histórico removido
      expect(homeController.listaHistorico.any((historico) => historico.id == historicoToRemove.id), isFalse);
    });

    test('clearHistorico() should remove all historicos and refresh the list', () async {
      final mockHistoricoDao = MockHistoricoDao();
      final homeController = HomeController(historicoDao: mockHistoricoDao);

      // Stub do método findAll() para retornar uma lista vazia, representando que todos os históricos foram limpos.
      when(mockHistoricoDao.findAll()).thenAnswer((_) async => []);

      // Configuração do mock para o método deleteAll()
      when(mockHistoricoDao.deleteAll()).thenAnswer((_) async => 1);

      // Executando o método sob teste
      await homeController.clearHistorico();

      // Verificações
      verify(mockHistoricoDao.deleteAll()).called(1); // Verifica se deleteAll foi chamado.
      verify(mockHistoricoDao.findAll()).called(1); // Verifica se findAll foi chamado para atualizar a lista após a limpeza.
      expect(homeController.listaHistorico.isEmpty, isTrue); // Verifica se a lista de históricos está vazia após a limpeza.
    });

  });
}

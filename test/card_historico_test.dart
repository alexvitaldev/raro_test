import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/model/historico_model.dart';
import 'package:raro_test/widgets/card_historico.dart';
import 'package:get_it/get_it.dart';

// Criando um mock para HomeController
class MockHomeController extends Mock implements HomeController {}

void main() {
  // Configuração inicial para os testes
  setUpAll(() {
    // Registrando o mock no GetIt
    final homeControllerMock = MockHomeController();
    GetIt.I.registerSingleton<HomeController>(homeControllerMock);
  });

  testWidgets('Displays correct information', (WidgetTester tester) async {
    // Modelo de dados para o teste
    final historico = HistoricoModel(
      id: 1,
      descricaoVaga: 'Vaga 01',
      placaVeiculo: 'ABC-1234',
      entrada: DateTime(2024, 1, 1, 10, 30),
      saida: DateTime(2024, 1, 1, 12, 30),
    );

    // Inflando o widget no ambiente de teste
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: HistoricoCard(historico: historico),
      ),
    ));

    // Verifica se as informações do histórico são exibidas corretamente
    expect(find.text('Saída'), findsOneWidget);
    expect(find.text('Historico ID: 1'), findsOneWidget);
    expect(find.text('Descrição Vaga: Vaga 01'), findsOneWidget);
    expect(find.text('Placa Veiculo: ABC-1234'), findsOneWidget);
    expect(find.text('Data entrada: 01/01/2024 - 10:30'), findsOneWidget);
    expect(find.text('Data saida: 01/01/2024 - 12:30'), findsOneWidget);
  });

  // Limpeza após os testes
  tearDownAll(() {
    GetIt.I.unregister<HomeController>();
  });
}

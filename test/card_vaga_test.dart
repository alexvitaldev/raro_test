import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:raro_test/widgets/card_vaga.dart';

void main() {
  group('VagaCard Tests', () {
    testWidgets('Displays correct information for occupied vaga', (WidgetTester tester) async {
      // Criação de modelos de dados para teste
      final veiculo = VeiculoModel(id: 1, placa: 'ABC-1234', entrada: DateTime(2022, 1, 1, 10, 30));
      final vaga = VagaModel(id: 1, description: 'Vaga Teste', idVeiculo: 1, veiculo: veiculo);

      // Inflando o widget no ambiente de teste
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VagaCard(vaga: vaga, veiculo: veiculo),
        ),
      ));

      // Verificações
      expect(find.text('Vaga Teste'), findsOneWidget);
      expect(find.text('Vaga ID: 1'), findsOneWidget);
      expect(find.text('Ocupada'), findsOneWidget);
      expect(find.text('Placa do Veículo: ABC-1234'), findsOneWidget);
      expect(find.text('Entrada: ${DateFormat('dd/MM/yyyy - HH:mm').format(veiculo.entrada)}'), findsOneWidget);
    });

    testWidgets('Displays correct information for free vaga', (WidgetTester tester) async {
      // Criação de modelo de dados para teste
      final vaga = VagaModel(id: 2, description: 'Vaga Livre');

      // Inflando o widget no ambiente de teste
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: VagaCard(vaga: vaga),
        ),
      ));

      // Verificações
      expect(find.text('Vaga Livre'), findsOneWidget);
      expect(find.text('Vaga ID: 2'), findsOneWidget);
      expect(find.text('Livre'), findsOneWidget);
      // Verifica que detalhes do veículo não são mostrados para vagas livres
      expect(find.text('Placa do Veículo:'), findsNothing);
    });
  });
}

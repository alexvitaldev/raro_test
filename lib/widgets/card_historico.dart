import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/model/historico_model.dart';

class HistoricoCard extends StatelessWidget {
  final HistoricoModel historico;

  HistoricoCard({Key? key, required this.historico}) : super(key: key);

  final HomeController _homeController = GetIt.I<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteConfirmationDialog(context),
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              _infoText('Historico ID: ${historico.id}'),
              _infoText('Descrição Vaga: ${historico.descricaoVaga}'),
              _infoText('Placa Veiculo: ${historico.placaVeiculo}'),
              const SizedBox(height: 16),
              _infoText('Data entrada: ${formatDateTime(historico.entrada)}'),
              if (historico.saida != null)
                _infoText('Data saida: ${formatDateTime(historico.saida!)}'),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            historico.saida != null ? "Saída" : "Entrada",
            style: TextStyle(fontSize: 20.0, color: historico.saida != null ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        Icon(Icons.remove_circle, color: Colors.red[400]),
      ],
    );
  }

  Text _infoText(String text) => Text(text);

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir Histórico"),
          content: Text("Tem certeza que deseja excluir o histórico ${historico.id}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Sim, excluir!"),
              onPressed: () async {
                await _homeController.deleteHistorico(historico);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Histórico excluído com sucesso!')));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    return formatter.format(dateTime);
  }
}

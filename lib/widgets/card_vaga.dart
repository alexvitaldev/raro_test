import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:raro_test/screens/form_vaga.dart';

class VagaCard extends StatelessWidget {
  final VagaModel vaga;
  final VeiculoModel? veiculo;

  const VagaCard({Key? key, required this.vaga, this.veiculo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = vaga.idVeiculo != null;

    return GestureDetector(
      onTap: () => _navigateToVagaForm(context),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(isOccupied),
              const SizedBox(height: 8),
              Text('Vaga ID: ${vaga.id}'),
              if (isOccupied) _buildVehicleDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeaderRow(bool isOccupied) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            vaga.description,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        _buildStatusIndicator(isOccupied),
      ],
    );
  }

  Widget _buildStatusIndicator(bool isOccupied) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isOccupied ? Colors.red : Colors.green,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          isOccupied ? "Ocupada" : "Livre",
          style: TextStyle(color: isOccupied ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildVehicleDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Placa do Veículo: ${veiculo?.placa ?? 'N/A'}'),
        Text('Entrada: ${formatDateTime(veiculo?.entrada ?? DateTime.now())}'),
        if (veiculo?.saida != null) Text('Saída: ${formatDateTime(veiculo!.saida!)}'),
      ],
    );
  }

  void _navigateToVagaForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VagaForm(vaga: vaga),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    return formatter.format(dateTime);
  }
}

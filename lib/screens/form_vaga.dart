import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:raro_test/screens/new_veiculo_screen.dart';

class VagaForm extends StatefulWidget {
  VagaModel? vaga;
  VagaForm({Key? key, this.vaga});

  @override
  _VagaFormState createState() => _VagaFormState();
}

class _VagaFormState extends State<VagaForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _homeController = GetIt.I<HomeController>();
  final _placaController = TextEditingController();

  DateTime _entrada = DateTime.now();
  DateTime? _saida;

  @override
  void initState() {
    super.initState();
    if (widget.vaga != null) {
      _descriptionController.text = widget.vaga!.description;
      _homeController.vagaSelecionada = widget.vaga;
      if(widget.vaga!.veiculo != null) {
        _entrada = widget.vaga!.veiculo!.entrada;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      title: Text(widget.vaga == null ? 'Criar Vaga' : 'Editar Vaga'),
      actions: [
        widget.vaga != null ?
        GestureDetector(
          onTap: (){
            _showDeleteConfirmationDialog(context, widget.vaga!);
          },
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: Icon(Icons.delete),
          ),
        ) : Container()
      ],
    );
  }

  Widget _buildBody(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVagaInfo(),
          const SizedBox(height: 16,),
          _buildVeiculoInfo(),
          const SizedBox(height: 16),
          _buildSalvarVaga(),
          _buildVeiculoButton(),
        ],
      ),
    );
  }

  Widget _buildVagaInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Informações da vaga:"),
        const SizedBox(height: 16,),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Descrição',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira uma descrição';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVeiculoInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.vaga != null && widget.vaga!.veiculo != null
            ? const Text("Informações do veículo:")
            : Container(),
        widget.vaga != null && widget.vaga!.veiculo != null ?
        Container(
          margin: EdgeInsets.only(top: 16),
          child: TextFormField(
            controller: _placaController,
            decoration: InputDecoration(
              labelText: widget.vaga == null || widget.vaga!.veiculo == null
                  ? 'Placa do Veículo'
                  : "Placa: ${widget.vaga!.veiculo!.placa}",
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.directions_car),
            ),
            readOnly: true,
            enabled: false,
          ),
        ) : Container(),
        widget.vaga != null && widget.vaga!.veiculo != null ?
        Container(
          margin: EdgeInsets.only(top: 16),
          child: TextFormField(
            controller: _placaController,
            decoration: InputDecoration(
              labelText: "Entrada:  ${DateFormat('dd/MM/yyyy HH:mm').format(_entrada)}",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
            ),
            readOnly: true,
            enabled: false,
          ),
        ) : Container(),
      ],
    );
  }

  Widget _buildSalvarVaga() {
    return
      Center(child:
      ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: Text(widget.vaga != null ? 'Salvar Vaga' : 'Criar Vaga'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if(widget.vaga != null){
              widget.vaga!.description = _descriptionController.text;
              _homeController.updateVaga(widget.vaga!);
            }else{
              VagaModel vaga = new VagaModel(description: _descriptionController.text);
              _homeController.createVaga(vaga);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Vaga salva com sucesso!')),
            );
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
        ),
      ),);
  }

  Widget _buildVeiculoButton() {
    return Column(
      children: [
        if (widget.vaga != null) ...[
          const SizedBox(height: 16),
          widget.vaga!.veiculo == null ?
          Center(
            child: ElevatedButton.icon(
              icon: Center(child: Icon(Icons.directions_car)),
              label: Text('Adicionar Veículo à Vaga'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewVeiculoScreen(vaga: widget.vaga),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
          ) :
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.directions_car),
              label: const Text('Saìda Veiculo'),
              onPressed: () async{
                VeiculoModel veiculo = widget.vaga!.veiculo!;
                //_showSaidaVeiculoDialog(context, veiculo);
                _selectDateTime(context, veiculo);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
          ) ,
        ]
      ],
    );
  }

  // Função para selecionar data e hora com validação apenas para saída
  Future<void> _selectDateTime(BuildContext context, veiculo) async {
    // A data/hora inicial, primeira e última para seleção são definidas com base na necessidade de apenas validar a saída.
    final now = DateTime.now();
    final initialDate = _entrada.add(Duration(seconds: 1)); // Inicializa sempre com a data de entrada para a saída
    final firstDate = _entrada.add(Duration(seconds: 1)); // A primeira data possível é logo após a entrada
    final lastDate = DateTime(2025); // Define uma data máxima arbitrária

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        final DateTime result = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Validar se a data/hora selecionada para saída está após a entrada
        if (result.isBefore(_entrada)) {
          return _showInvalidDateTimeAlert(context, 'A saída deve ser após a entrada.');
        }

        setState(() {
          // Atualiza a saída com o resultado escolhido
          _saida = result;
        });

        veiculo.saida = _saida;
        _showSaidaVeiculoDialog(context, veiculo);

      }
    }
  }

  void _showInvalidDateTimeAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Inválida'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, VagaModel vaga) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir Vaga"),
          content: Text("Tem certeza que deseja excluir a vaga ${vaga.description}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
              },
            ),
            TextButton(
              child: const Text("Sim, excluir!"),
              onPressed: () {
                _homeController.deleteVaga(vaga);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSaidaVeiculoDialog(BuildContext context, VeiculoModel veiculo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Saida Veiculo"),
          content: Text("Tem certeza que deseja dar saida no veiculo ${veiculo.placa}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
              },
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () async{
                await _homeController.saidaVeiculo( widget.vaga!.veiculo!, widget.vaga!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Saida registrada com sucesso!')),
                );
                setState(() {
                  widget.vaga!.veiculo = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

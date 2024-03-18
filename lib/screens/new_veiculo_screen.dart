import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/model/veiculo_model.dart';
import 'package:raro_test/screens/form_vaga.dart';

class NewVeiculoScreen extends StatefulWidget {

  VagaModel? vaga;
  NewVeiculoScreen({this.vaga});

  @override
  _NewVeiculoScreenState createState() => _NewVeiculoScreenState();
}

class _NewVeiculoScreenState extends State<NewVeiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _vagaController = TextEditingController();
  DateTime _entrada = DateTime.now();
  DateTime? _saida;
  String selectedItem = 'Clique para selecionar';
  final _homeController = GetIt.I<HomeController>();
  VagaModel? _vagaSelecionada;

  @override
  void initState() {
    if(widget.vaga != null){
      _vagaSelecionada = widget.vaga;
    }
    super.initState();
  }

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
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
      title: const Text('Registrar Veículo'),
    );
  }

  Widget _buildBody(){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: _builForm(),
      ),
    );
  }

  Widget _builForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _placaField(),
          const SizedBox(height: 16,),
          _vagaField(),
          const SizedBox(height: 16,),
          _saveButton()
        ],
      ),
    );
  }

  Widget _placaField() {
    return
      TextFormField(
        controller: _placaController,
        decoration: InputDecoration(
          labelText: 'Placa do Veículo',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.directions_car),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Insira a placa do veículo';
          }else if(value.trim().length < 4){ //validar placa
            return 'Informe uma placa vàlida.';
          }
          return null;
        },
      );
  }

  Widget _vagaField() {
    return Column(
      children: [
        TextFormField(
          controller: _vagaController,
          decoration: InputDecoration(
            labelText: _vagaSelecionada == null ? 'Vaga do Veículo' : _vagaSelecionada!.description,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.local_parking),
            // Para evitar que o teclado apareça quando o campo ganhar foco
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {
                // Esconder o teclado caso esteja aberto
                FocusScope.of(context).requestFocus(FocusNode());
                // Chamar o método para abrir a dialog
                _showSelectItemDialog();
              },
            ),
          ),
          readOnly: true, // Torna o campo somente leitura, evitando que o teclado apareça
          onTap: () {
            // Esconder o teclado caso esteja aberto
            FocusScope.of(context).requestFocus(FocusNode());
            // Chamar o método para abrir a dialog
            _showSelectItemDialog();
          },
          validator: (value) {
            if (_vagaSelecionada == null) {
              return 'Escolha a vaga do veículo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16,),
        _dateTimePickers(),
      ],
    );
  }

  Widget _dateTimePickers(){
        return Column(
        children: [
          ListTile(
            title: Text('Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(_entrada)}', style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Icon(Icons.login, color: Colors.green),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDateTime(context, isEntrada: true),
          ),
          if (_saida != null)
            ListTile(
              title: Text('Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(_saida!)}', style: TextStyle(fontWeight: FontWeight.bold)),
              leading: Icon(Icons.logout, color: Colors.red),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context, isEntrada: false),
            )
        ],
        );
    }

  Widget _saveButton(){
    return
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // background (button) color
            onPrimary: Colors.white, // foreground (text) color
          ),
          onPressed: () async {
            _salvarVeiculo();
          },
          child: const Text('Salvar Veículo'),
        ),
      );
  }

  /* Funções Auxiliares */

  // Função para selecionar data e hora com validação
  Future<void> _selectDateTime(BuildContext context, {required bool isEntrada}) async {
    final now = DateTime.now();
    final initialDate = isEntrada ? now : _entrada.add(Duration(seconds: 1));
    final firstDate = isEntrada ? now : _entrada.add(Duration(seconds: 1));
    final lastDate = DateTime(2025);

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

        // Validar se a data/hora selecionada está no futuro em relação a agora e, para a saída, após a entrada
        if (isEntrada && result.isBefore(now)) {
          _showInvalidDateTimeAlert(context, 'A entrada não pode ser no passado.');
          return;
        } else if (!isEntrada && (result.isBefore(now) || result.isBefore(_entrada))) {
          _showInvalidDateTimeAlert(context, 'A saída deve ser após a entrada e no futuro.');
          return;
        }

        setState(() {
          if (isEntrada) {
            _entrada = result;
          } else {
            _saida = result;
          }
        });
      }
    }
  }

  void _showSelectItemDialog() {
    List<VagaModel> listaVagas = _homeController.vagaList;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione uma vaga'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaVagas.length,
              itemBuilder: (context, index) {
                VagaModel vaga = listaVagas[index];
                bool vagaReservada = vaga.veiculo != null;
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text("${vaga.description}")),
                      ],
                    ),
                    subtitle: Text("Estado: ${vagaReservada ? 'Ocupada' : 'Livre'}"),
                    onTap: vagaReservada ? null : () { // Desabilita o onTap se a vaga está reservada.
                      _vagaSelecionada = vaga;
                      print("Vaga selecionada: ${vaga.description}");
                      Navigator.of(context).pop(vaga); // Retorna a vaga selecionada.
                    },
                    enabled: !vagaReservada, // Desabilita o ListTile se a vaga está reservada.
                    // Aplica um efeito visual de desfoque se a vaga está reservada.
                    tileColor: vagaReservada ? Colors.grey.shade300 : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _salvarVeiculo() async{
    if (_formKey.currentState!.validate()) {

      VeiculoModel veiculo = VeiculoModel(placa: _placaController.text, entrada: _entrada);
      int idVeiculo = await _homeController.createVeiculo(veiculo, _vagaSelecionada!);
      veiculo.id = idVeiculo;

      _vagaSelecionada!.idVeiculo = idVeiculo;
      await _homeController.updateVaga(_vagaSelecionada!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo salvo com sucesso!')),
      );

      _homeController.vagaSelecionada!.veiculo = veiculo;

      if(widget.vaga != null){
        widget.vaga!.veiculo = veiculo;
        VagaModel vaga = widget.vaga!;
        vaga.veiculo = veiculo;
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VagaForm(vaga: vaga,),
          ),
        );
      }else{
        Navigator.pop(context);
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

}

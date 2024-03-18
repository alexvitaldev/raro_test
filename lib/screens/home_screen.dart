import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:raro_test/model/vaga_model.dart';
import 'package:raro_test/screens/form_vaga.dart';
import 'package:raro_test/screens/historico_screen.dart';
import 'package:raro_test/screens/new_veiculo_screen.dart';
import 'package:raro_test/widgets/card_vaga.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = GetIt.I<HomeController>();

  @override
  void initState() {
    super.initState();
    _homeController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        _buildHistoryButton(),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.remove,
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('Abrindo Dial'),
      onClose: () => print('Fechando Dial'),
      tooltip: 'Opções',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.directions_car),
          backgroundColor: Colors.red,
          label: 'Adicionar Veículo',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewVeiculoScreen())),
        ),
        SpeedDialChild(
          child: Icon(Icons.place),
          backgroundColor: Colors.green,
          label: 'Adicionar Vaga',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VagaForm())),
        ),
      ],
    );
  }

  Widget _buildHistoryButton() {
    return ContainerPlus(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoricoScreen())),
      margin: EdgeInsets.only(right: 8),
      child: Text("Histórico"),
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (_) {
        var listaVagas = _homeController.vagaList;

        if (listaVagas.isEmpty) {
          return _buildEmptyState();
        }
        return _buildVagasList(listaVagas);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Nenhuma vaga criada!"),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Criar Vagas'),
            onPressed: _criarVagas,
            style: ElevatedButton.styleFrom(primary: Colors.green, onPrimary: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildVagasList(List<VagaModel> listaVagas) {
    return ContainerPlus(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16, bottom: 64),
              itemCount: listaVagas.length,
              itemBuilder: (context, index) {
                VagaModel vaga = listaVagas[index];

                return VagaCard(vaga: vaga, veiculo: vaga.veiculo,);
              },
            ),
          ),
        ],
      ),
    );
  }

  _criarVagas() async {
    await _homeController.createVaga(VagaModel(id: 1, description: "Vaga VIP"));
    await _homeController.createVaga(VagaModel(id: 2, description: "Vaga 2"));
    await _homeController.createVaga(VagaModel(id: 3, description: "Vaga 3"));
    await _homeController.createVaga(VagaModel(id: 4, description: "Vaga 4"));
  }
}

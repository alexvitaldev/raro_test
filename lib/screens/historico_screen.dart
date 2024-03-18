import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:raro_test/controller/home_controller.dart';
import 'package:raro_test/model/historico_model.dart';
import 'package:raro_test/widgets/card_historico.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {

  List<HistoricoModel> listaHistorico = [];
  final _homeController = GetIt.I<HomeController>();

  @override
  void initState() {
    _homeController.getHistoricos();
    super.initState();
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
      title: Text("Històrico"),
      actions: [
        Observer(
          builder: (_){
            if(!_homeController.listaHistorico.isEmpty){
              return ContainerPlus(
                onTap: (){
                  _showDeleteHistoricoDialog(context);
                },
                margin: EdgeInsets.only(right: 8),
                child: Text("Limpar Històrico"),
              );
            }
            return Container();
          },
        )
      ],
    );
  }

  Widget _buildBody() {
    return Observer(
        builder: (_) {
          listaHistorico = _homeController.listaHistorico;

          if(listaHistorico.isEmpty){
            return Center(child: Text("Nenhum histórico encontrado!"));
          }

          return ContainerPlus(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16, bottom: 64),
              itemCount: listaHistorico.length,
              itemBuilder: (context, index) {
                HistoricoModel historico = listaHistorico[index];

                return HistoricoCard(historico: historico,);

              },
            ),
          );
        }
    );
  }

  _showDeleteHistoricoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Limpar Histórico"),
          content: const Text("Tem certeza que deseja excluir o histórico de veìculos?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a dialog sem fazer nada
              },
            ),
            TextButton(
              child: const Text("Excluir"),
              onPressed: () async{
                await _homeController.clearHistorico();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Histórico excluído com sucesso!')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:mockito/annotations.dart';
import 'package:raro_test/model/vaga_dao.dart';
import 'package:raro_test/model/veiculo_dao.dart';
import 'package:raro_test/model/historico_dao.dart';

// Anotação para gerar os arquivos de Mocks.
@GenerateMocks([VagaDao, VeiculoDao, HistoricoDao])
void main() {}
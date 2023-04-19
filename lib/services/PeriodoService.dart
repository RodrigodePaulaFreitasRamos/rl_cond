import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/service/crud_service.dart';

abstract class PeriodoService implements CrudService<Periodo, int> {

  bool haPeriodo(DateTime data);

  Periodo ler(DateTime data);

}

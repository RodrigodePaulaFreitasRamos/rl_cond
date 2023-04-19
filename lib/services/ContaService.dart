import 'dart:math';

import 'package:app_condominio/domain/conta.dart';

abstract class ContaService extends CrudService<Conta, int> {
  
  BigDecimal saldoAtual();
  
}
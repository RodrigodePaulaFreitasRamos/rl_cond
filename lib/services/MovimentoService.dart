import 'dart:math' show Decimal;
import 'package:app_condominio/domain/categoria.dart';
import 'package:app_condominio/domain/conta.dart';
import 'package:app_condominio/domain/lancamento.dart';
import 'package:app_condominio/domain/movimento.dart';
import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/domain/subcategoria.dart';
import 'package:app_condominio/service/crud_service.dart';

abstract class MovimentoService implements CrudService<Movimento, int> {
  Decimal somaLancamentosEntre(Collection<Conta> contas, DateTime inicio, DateTime fim, bool reducao);

  Decimal somaLancamentosEntre(Collection<Conta> contas, DateTime inicio, DateTime fim, Subcategoria subcategoria);

  Decimal somaLancamentosPeriodo(Collection<Conta> contas, Periodo periodo, Subcategoria subcategoria);

  Decimal somaLancamentosPeriodo(Collection<Conta> contas, Periodo periodo, Categoria categoria);

  Decimal somaLancamentosDesde(Collection<Conta> contas, DateTime inicio, bool reducao);

  List<Lancamento> listarLancamentosEntre(Collection<Conta> contas, DateTime inicio, DateTime fim);
}

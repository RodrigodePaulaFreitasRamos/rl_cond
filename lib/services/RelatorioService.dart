import 'package:app_condominio/domain/categoria.dart';
import 'package:app_condominio/domain/cobranca.dart';
import 'package:app_condominio/domain/moradia.dart';
import 'package:app_condominio/domain/movimento.dart';
import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/domain/subcategoria.dart';
import 'package:app_condominio/domain/tipo_categoria.dart';
import 'package:decimal/decimal.dart';

abstract class RelatorioService {
  /// Retorna um Decimal com a soma do saldo de todas as Contas do Condomínio.
  /// Nunca retorna null, se não houver contas, retorna Decimal.zero.
  Decimal saldoAtualTodasContas();

  /// Retorna um Decimal com o saldo de todas as Contas do Condomínio no início
  /// do dia passado no parâmetro. Nunca retorna null, se não houver contas,
  /// retorna Decimal.zero.
  Decimal saldoInicialTodasContasEm(DateTime data);

  /// Retorna um Decimal com o saldo de todas as Contas do Condomínio no fim do
  /// dia passado no parâmetro. Nunca retorna null, se não houver contas,
  /// retorna Decimal.zero.
  Decimal saldoFinalTodasContasEm(DateTime data);

  /// Retorna um Decimal com o valor total da inadimplência do Condomínio na
  /// data atual (considera o valor total da Cobrança, com acréscimos e
  /// deduções). Nunca retorna null, se não houver inadimplência, retorna
  /// Decimal.zero.
  Decimal inadimplenciaAtual();

  /// Retorna uma lista com dois Decimais, sendo o primeiro a soma dos lançamentos
  /// de receitas do mês atual, e o segundo a soma dos lançamentos de despesas do
  /// mês atual. Nunca retorna null, se não houver lançamentos, retorna Decimal.zero
  /// na respectiva posição da lista.
  List<Decimal> receitaDespesaMesAtual();

  /// Retorna uma lista com dois Decimais, sendo o primeiro a soma dos lançamentos
  /// de receitas dentro das datas informadas no parâmetro, e o segundo a soma dos
  /// lançamentos de despesas dentro das datas informadas no parâmetro. Nunca
  /// retorna null, se não houver lançamentos, retorna Decimal.zero na respectiva
  /// posição da lista.
  List<Decimal> receitaDespesaEntre(DateTime inicio, DateTime fim);

  /// Retorna uma lista com dois Decimais, sendo o primeiro a soma dos lançamentos
  /// de receitas realizadas do Período atual, e o segundo a soma dos lançamentos
  /// de despesas realizadas do Período atual. Nunca retorna null, se não houver
  /// lançamentos, retorna Decimal.zero na respectiva posição da lista.
  List<Decimal> receitaDespesaRealizadaPeriodoAtual();

  // Retorna uma lista com dois Decimais, sendo o primeiro a soma das receitas orçadas do Período atual e o segundo a soma das despesas orçadas do Período atual. Nunca retorna null, se não houver lançamentos, retorna Decimal.zero na respectiva posição da lista.
List<Decimal> receitaDespesaAtual() {
// Lógica para obter as receitas orçadas do Período atual
Decimal receitaAtual = obterReceitasOrcadasPeriodoAtual();

// Lógica para obter as despesas orçadas do Período atual
Decimal despesaAtual = obterDespesasOrcadasPeriodoAtual();

// Cria a lista com os valores obtidos
List<Decimal> listaReceitaDespesaAtual = [receitaAtual, despesaAtual];

return listaReceitaDespesaAtual;
}

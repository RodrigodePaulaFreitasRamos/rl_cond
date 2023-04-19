import 'package:flutter/material.dart';
import 'package:app_condominio/service/conta_service.dart';
import 'package:app_condominio/service/movimento_service.dart';
import 'package:app_condominio/service/cobranca_service.dart';
import 'package:app_condominio/service/orcamento_service.dart';
import 'package:app_condominio/service/periodo_service.dart';
import 'package:app_condominio/service/subcategoria_service.dart';
import 'package:app_condominio/service/categoria_service.dart';
import 'package:app_condominio/domain/categoria.dart';
import 'package:app_condominio/domain/cobranca.dart';
import 'package:app_condominio/domain/conta.dart';
import 'package:app_condominio/domain/moradia.dart';
import 'package:app_condominio/domain/movimento.dart';
import 'package:app_condominio/domain/orcamento.dart';
import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/domain/subcategoria.dart';
import 'package:app_condominio/domain/tipo_categoria.dart';

class RelatorioServiceImpl implements RelatorioService {
  
  ContaService contaService;
  MovimentoService movimentoService;
  CobrancaService cobrancaService;
  OrcamentoService orcamentoService;
  PeriodoService periodoService;
  SubcategoriaService subcategoriaService;
  CategoriaService categoriaService;

  RelatorioServiceImpl({
    required this.contaService,
    required this.movimentoService,
    required this.cobrancaService,
    required this.orcamentoService,
    required this.periodoService,
    required this.subcategoriaService,
    required this.categoriaService
  });

  @override
  BigDecimal saldoAtualTodasContas() {
    return contaService.saldoAtual();
  }

  @override
  BigDecimal saldoInicialTodasContasEm(LocalDate data) {
    BigDecimal saldo = contaService.saldoAtual();
    BigDecimal[] lancamentos = receitaDespesaDesde(contaService.listar(), data);
    return saldo.subtract(lancamentos[0]).add(lancamentos[1]);
  }

  @override
  BigDecimal saldoFinalTodasContasEm(LocalDate data) {
    return saldoInicialTodasContasEm(data.plusDays(1));
  }

  @override
  BigDecimal inadimplenciaAtual() {
    return cobrancaService.inadimplencia();
  }

  BigDecimal[] receitaDespesaEntre(Collection<Conta> contas, LocalDate inicio, LocalDate fim) {
    BigDecimal[] resultado = new BigDecimal[2];
    if (contas.isNotEmpty) {
      resultado[0] = movimentoService.somaLancamentosEntre(contas, inicio, fim, false);
      resultado[1] = movimentoService.somaLancamentosEntre(contas, inicio, fim, true);
    }
    if (resultado[0] == null) {
      resultado[0] = BigDecimal.zero;
    }
    if (resultado[1] == null) {
      resultado[1] = BigDecimal.zero;
    }
    return resultado;
  }

  BigDecimal[] receitaDespesaDesde(Collection<Conta> contas, LocalDate inicio) {
BigDecimal[] resultado = new BigDecimal[2];
if (!contas.isEmpty()) {
resultado[0] = movimentoService.somaLancamentosDesde(contas, inicio, false);
resultado[1] = movimentoService.somaLancamentosDesde(contas, inicio, true);
}
if (resultado[0] == null) {
resultado[0] = BigDecimal.ZERO;
}
if (resultado[1] == null) {
resultado[1] = BigDecimal.ZERO;
}
return resultado;
}
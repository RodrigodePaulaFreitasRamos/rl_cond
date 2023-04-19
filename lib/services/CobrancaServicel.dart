import 'package:app_condominio/domain/cobranca.dart';
import 'package:app_condominio/service/crud_service.dart';
import 'dart:math' show BigDecimal;
import 'dart:core' show List;

abstract class CobrancaService extends CrudService<Cobranca, int> {
  /**
   * Retorna um BigDecimal com o valor total da inadimplência do
   * Condomínio na data atual (considera o valor total da Cobrança, com
   * acréscimos e deduções). Nunca retorna nulo, se não houver
   * inadimplência, retorna BigDecimal.ZERO.
   */
  BigDecimal inadimplencia();

  /**
   * Retorna uma lista do tipo List<Cobranca> com todas as Cobrancas do Condomínio
   * vencidas na data atual (considera o valor total da Cobrança, com acréscimos e deduções).
   * Nunca retorna nulo, se não houver inadimplência, retorna uma lista vazia.
   */
  List<Cobranca> listarInadimplencia();
}
import 'package:app/condominio/dao/orcamento_dao.dart';
import 'package:app/condominio/domain/categoria.dart';
import 'package:app/condominio/domain/orcamento.dart';
import 'package:app/condominio/domain/periodo.dart';
import 'package:app/condominio/domain/subcategoria.dart';
import 'package:app/condominio/domain/enums/tipo_categoria.dart';
import 'package:app/condominio/service/orcamento_service.dart';
import 'package:app/condominio/service/periodo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class OrcamentoServiceImpl implements OrcamentoService {
  OrcamentoDao _orcamentoDao;
  PeriodoService _periodoService;

  OrcamentoServiceImpl({
    required OrcamentoDao orcamentoDao,
    required PeriodoService periodoService,
  }) {
    _orcamentoDao = orcamentoDao;
    _periodoService = periodoService;
  }

  @override
  void salvar(Orcamento entidade) {
    if (entidade.idOrcamento == null) {
      _orcamentoDao.save(entidade);
    }
  }

  @override
  Future<Orcamento> ler(int id) async {
    return _orcamentoDao.findById(id);
  }

  @override
  Future<List<Orcamento>> listar() async {
    return _orcamentoDao.findAllByPeriodoInOrderByPeriodoDescSubcategoriaAsc(
        _periodoService.listar());
  }

  @override
  Future<Page<Orcamento>> listarPagina(Pageable pagina) async {
    return _orcamentoDao.findAllByPeriodoInOrderByPeriodoDescSubcategoriaAsc(
        _periodoService.listar(), pagina);
  }

  @override
  void editar(Orcamento entidade) {
    _orcamentoDao.save(entidade);
  }

  @override
  void excluir(Orcamento entidade) {
    _orcamentoDao.delete(entidade);
  }

  @override
  Future<void> validar(Orcamento entidade, BindingResult validacao) async {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idOrcamento == null) {
      // Não permitir incluir orçamento repetido
      if (entidade.periodo != null &&
          entidade.subcategoria != null &&
          _orcamentoDao.existsByPeriodoAndSubcategoria(
              entidade.periodo!, entidade.subcategoria!)) {
        validacao.rejectValue("subcategoria", "Unique");
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      // Não permitir um orçamento repetido
      if (entidade.periodo != null &&
          entidade.subcategoria != null &&
          _orcamentoDao.existsByPeriodoAndSubcategoriaAndIdOrcamentoNot(
              entidade.periodo!,
              entidade.subcategoria!,
              entidade.idOrcamento!)) {
        validacao.rejectValue("subcategoria", "Unique");
      }
    }
// VALIDAÇÕES EM AMBOS
    if (entidade.periodo != null && entidade.periodo!.encerrado!) {
      validacao.rejectValue("periodo", "Final");
    }
  }

  @override
  Future<BigDecimal> somaOrcamentos(Periodo? periodo, TipoCategoria tipo) async {
    if (periodo != null) {
      return await _orcamentoDao.sumByPeriodoAndSubcategoria_CategoriaPai_Tipo(periodo, tipo);
    } else {
      throw ArgumentError("O parâmetro 'periodo' não pode ser nulo.");
    }
  }
}

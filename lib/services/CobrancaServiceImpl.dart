import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_condominio/service/UsuarioService.dart';
import 'package:app_condominio/dao/CobrancaDao.dart';
import 'package:app_condominio/domain/Cobranca.dart';
import 'package:app_condominio/domain/Condominio.dart';
import 'package:app_condominio/domain/enums/MotivoEmissao.dart';
import 'package:app_condominio/domain/enums/SituacaoCobranca.dart';

class CobrancaServiceImpl implements CobrancaService {
  CobrancaDao cobrancaDao;
  UsuarioService usuarioService;

  CobrancaServiceImpl({required this.cobrancaDao, required this.usuarioService});

  @override
  void salvar(Cobranca entidade) {
    if (entidade.idCobranca == null) {
      padronizar(entidade);
      cobrancaDao.save(entidade);
    }
  }

  @override
  Cobranca ler(int id) {
    return cobrancaDao.findById(id).get();
  }

  @override
  List<Cobranca> listar() {
    Condominio condominio = usuarioService.lerLogado().getCondominio();
    if (condominio == null) {
      return List<Cobranca>.empty();
    }
    return condominio.getCobrancas();
  }

  @override
  Page<Cobranca> listarPagina(Pageable pagina) {
    Condominio condominio = usuarioService.lerLogado().getCondominio();
    if (condominio == null) {
      return Page.empty();
    }
    return cobrancaDao.findAllByCondominioOrderByDataEmissaoDescMoradiaAscNumeroAscParcelaAsc(condominio, pagina);
  }

  @override
  void editar(Cobranca entidade) {
    padronizar(entidade);
    cobrancaDao.save(entidade);
  }

  @override
  void excluir(Cobranca entidade) {
    cobrancaDao.delete(entidade);
  }

  @override
  void validar(Cobranca entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idCobranca == null) {
      if (entidade.dataEmissao != null && entidade.moradia != null &&
          cobrancaDao.existsByNumeroAndParcelaAndDataEmissaoAndMoradiaAndCondominio(entidade.numero,
              entidade.parcela, entidade.dataEmissao, entidade.moradia,
              usuarioService.lerLogado().getCondominio())) {
        validacao.rejectValue("moradia", "Unique", [0, entidade.toString()], null);
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO

else {
    if (entidade.dataEmissao != null && entidade.moradia != null &&
        cobrancaDao.existsByNumeroAndParcelaAndDataEmissaoAndMoradiaAndCondominioAndIdCobrancaNot(
            entidade.numero, entidade.parcela, entidade.dataEmissao,
            entidade.moradia, usuarioService.lerLogado().getCondominio(),
            entidade.idCobranca)) {
        validacao.rejectValue("moradia", "Unique", [0, entidade.toString()], null);
    }
    if (entidade.dataRecebimento != null) {
        // Realizar validações adicionais para a data de recebimento
    }
}
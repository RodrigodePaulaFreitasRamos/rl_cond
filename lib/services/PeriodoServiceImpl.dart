import 'package:app_condominio/dao/periodo_dao.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/service/periodo_service.dart';
import 'package:app_condominio/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:springframework/springframework.dart';

class PeriodoServiceImpl implements PeriodoService {
  PeriodoDao _periodoDao;
  UsuarioService _usuarioService;

  PeriodoServiceImpl(this._periodoDao, this._usuarioService);

  @override
  void salvar(Periodo entidade) {
    if (entidade.idPeriodo == null) {
      padronizar(entidade);
      _periodoDao.save(entidade);
    }
  }

  @override
  Future<Periodo> ler(int id) async {
    return _periodoDao.findById(id).get();
  }

  @override
  Future<List<Periodo>> listar() async {
    Condominio condominio = _usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return <Periodo>[];
    }
    return condominio.periodos;
  }

  @override
  Future<Page<Periodo>> listarPagina(Pageable pagina) async {
    Condominio condominio = _usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return Page.empty(pagina);
    }
    return _periodoDao.findAllByCondominioOrderByInicioDesc(condominio, pagina);
  }

  @override
  Future<bool> haPeriodo(DateTime data) async {
    return _periodoDao.existsByCondominioAndInicioLessThanEqualAndFimGreaterThanEqual(
        _usuarioService.lerLogado().condominio, data, data);
  }

  @override
  Future<Periodo> ler(DateTime data) async {
    return _periodoDao.findOneByCondominioAndInicioLessThanEqualAndFimGreaterThanEqual(
        _usuarioService.lerLogado().condominio, data, data);
  }

  @override
  void editar(Periodo entidade) {
    padronizar(entidade);
    _periodoDao.save(entidade);
  }

  @override
  void excluir(Periodo entidade) {
    _periodoDao.delete(entidade);
  }

  @override
  Future<void> validar(Periodo entidade, BindingResult validacao) async {
    // VALIDAÇÕES NA INCLUSÃO
if (entidade.idPeriodo == null) {
if (entidade.inicio != null && entidade.fim != null) {
// Não pode repetir período
if (_periodoDao.existsByCondominioAndInicioAfterAndFimBefore(
_usuarioService.lerLogado().condominio, entidade.inicio, entidade.fim)) {
validacao.rejectValue("inicio", "Conflito");
validacao.rejectValue("fim", "Conflito");
} else {
if (_periodoDao.existsByCondominioAndInicioLessThanEqualAndFimGreaterThanEqual(
_usuarioService.lerLogado().condominio, entidade.inicio, entidade.inicio)) {
validacao.rejectValue("inicio", "Unique");
}
if (_periodoDao.existsByCondominioAndInicioLessThanEqualAndFimGreaterThanEqual(
_usuarioService.lerLogado().condominio, entidade.fim, entidade.fim)) {
validacao.rejectValue("fim", "Unique");
}
}
}
}

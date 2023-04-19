import 'package:app_condominio/dao/bloco_dao.dart';
import 'package:app_condominio/domain/bloco.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/service/usuario_service.dart';
import 'package:flutter/material.dart';

class BlocoService {
  final BlocoDao blocoDao;
  final UsuarioService usuarioService;

  BlocoService({required this.blocoDao, required this.usuarioService});

  Future<void> salvar(Bloco entidade) async {
    if (entidade.idBloco == null) {
      padronizar(entidade);
      await blocoDao.save(entidade);
    }
  }

  Future<Bloco> ler(int id) async {
    return await blocoDao.findById(id);
  }

  Future<List<Bloco>> listar() async {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return <Bloco>[];
    }
    return condominio.blocos;
  }

  Future<List<Bloco>> listarPagina(Pageable pagina) async {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return <Bloco>[];
    }
    return blocoDao.findAllByCondominioOrderBySiglaAsc(condominio, pagina);
  }

  Future<void> editar(Bloco entidade) async {
    padronizar(entidade);
    await blocoDao.save(entidade);
  }

  Future<void> excluir(Bloco entidade) async {
    await blocoDao.delete(entidade);
  }

  Future<void> validar(Bloco entidade, BindingResult validacao) async {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idBloco == null) {
      // Sigla não pode repetir
      if (await blocoDao.existsBySiglaAndCondominio(
          entidade.sigla, usuarioService.lerLogado().condominio)) {
        validacao.rejectValue("sigla", "Unique");
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      // Sigla não pode repetir
      if (await blocoDao.existsBySiglaAndCondominioAndIdBlocoNot(
          entidade.sigla,
          usuarioService.lerLogado().condominio,
          entidade.idBloco)) {
        validacao.rejectValue("sigla", "Unique");
      }
    }
    // VALIDAÇÕES EM AMBOS
  }

  Future<void> padronizar(Bloco entidade) async {
    if (entidade.condominio == null) {
      entidade.condominio = usuarioService.lerLogado().condominio;
    }
  }
}

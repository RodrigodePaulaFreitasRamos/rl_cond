import 'package:app_condominio/dao/condominio_dao.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/domain/usuario.dart';
import 'package:app_condominio/service/condominio_service.dart';
import 'package:app_condominio/service/usuario_service.dart';
import 'package:flutter/material.dart';

class CondominioServiceImpl implements CondominioService {
  final CondominioDao _condominioDao;
  final UsuarioService _usuarioService;

  CondominioServiceImpl(this._condominioDao, this._usuarioService);

  @override
  void salvar(Condominio condominio) {
    if (condominio.idCondominio == null) {
      padronizar(condominio);
      _condominioDao.save(condominio);

      // Atualizar o ID do condomínio no cadastro do síndico
      Usuario sindico = _usuarioService.lerLogado();
      sindico.condominio = condominio;
      _usuarioService.editar(sindico);
    }
  }

  @override
  Condominio ler() {
    return _usuarioService.lerLogado().condominio;
  }

  @override
  void editar(Condominio condominio) {
    padronizar(condominio);
    _condominioDao.save(condominio);
  }

  @override
  void excluir(Condominio condominio) {
    _condominioDao.delete(condominio);
  }

  @override
  Condominio lerById(int id) {
    // Implementar ao fazer o usuário tipo ADMIN
    return null;
  }

  @override
  List<Condominio> listar() {
    // Implementar ao fazer o usuário tipo ADMIN
    return null;
  }

  @override
  Page<Condominio> listarPagina(Pageable pagina) {
    // Criar este método quando fizer página de listar condomínios (admin)
    return null;
  }

  @override
  void validar(Condominio entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idCondominio == null) {
      // CNPJ não pode repetir
      if (entidade.cnpj != null && _condominioDao.existsByCnpj(entidade.cnpj)) {
        validacao.rejectValue("cnpj", "Unique");
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      // CNPJ não pode repetir
      if (entidade.cnpj != null &&
          _condominioDao.existsByCnpjAndIdCondominioNot(entidade.cnpj, entidade.idCondominio)) {
        validacao.rejectValue("cnpj", "Unique");
      }
    }
    // VALIDAÇÕES EM AMBOS
  }

  @override
  void padronizar(Condominio entidade) {
    // Nada a padronizar por enquanto
  }
}
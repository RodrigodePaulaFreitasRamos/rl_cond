import 'package:flutter/cupertino.dart';
import 'package:app_condominio/dao/categoria_dao.dart';
import 'package:app_condominio/domain/categoria.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/domain/enums/tipo_categoria.dart';
import 'package:app_condominio/service/categoria_service.dart';
import 'package:app_condominio/service/usuario_service.dart';

class CategoriaServiceImpl implements CategoriaService {
  CategoriaDao categoriaDao = CategoriaDao();
  UsuarioService usuarioService = UsuarioService();

  @override
  void salvar(Categoria entidade) {
    if (entidade.idCategoria == null) {
      padronizar(entidade);
      categoriaDao.save(entidade);
    }
  }

  @override
  Categoria ler(int id) {
    return categoriaDao.findById(id);
  }

  @override
  List<Categoria> listar() {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return [];
    }
    return condominio.categorias;
  }

  @override
  Page<Categoria> listarPagina(Pageable pagina) {
    // TODO: Como paginar esta pagina?
    return null;
  }

  @override
  List<Categoria> listarReceitas() {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return [];
    }
    return categoriaDao.findAllByCondominioAndTipo(condominio, TipoCategoria.R);
  }

  @override
  List<Categoria> listarDespesas() {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return [];
    }
    return categoriaDao.findAllByCondominioAndTipo(condominio, TipoCategoria.D);
  }

  @override
  void editar(Categoria entidade) {
    padronizar(entidade);
    categoriaDao.save(entidade);
  }

  @override
  void excluir(Categoria entidade) {
    categoriaDao.delete(entidade);
  }

  @override
  void validar(Categoria entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idCategoria == null) {
      // Ordem não pode repetir
      if (categoriaDao.existsByOrdemAndCondominio(entidade.ordem,
          usuarioService.lerLogado().condominio)) {
        validacao.rejectValue("ordem", "Unique");
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      // Ordem não pode repetir
      if (categoriaDao.existsByOrdemAndCondominioAndIdCategoriaNot(
          entidade.ordem,
          usuarioService.lerLogado().condominio,
          entidade.idCategoria)) {
        validacao.rejectValue("ordem", "Unique");
      }
      // Não pode "alterar" o tipo da categoria de RECEITA para DESPESA e vice-versa
      Categoria anterior = ler(entidade.idCategoria);
      if (entidade.tipo != anterior.tipo) {
        validacao.rejectValue("tipo", "Final");
      }
      // Não pode ser filha dela mesma ou de uma das filhas dela
if ((entidade.categoriaPai != null) &&
(entidade.categoriaPai == entidade ||
entidade.categoriaPai.ordem.startsWith(entidade.ordem))) {
// Realize ação necessária caso a condição seja verdadeira
} else {
// Realize ação necessária caso a condição seja falsa
}
import 'package:app_condominio/dao/subcategoria_dao.dart';
import 'package:app_condominio/domain/subcategoria.dart';
import 'package:app_condominio/service/categoria_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubcategoriaServiceImpl implements SubcategoriaService {
  final SubcategoriaDao _subcategoriaDao;
  final CategoriaService _categoriaService;

  SubcategoriaServiceImpl({@required SubcategoriaDao subcategoriaDao, @required CategoriaService categoriaService})
      : _subcategoriaDao = subcategoriaDao,
        _categoriaService = categoriaService;

  @override
  void salvar(Subcategoria entidade) {
    if (entidade.idSubcategoria == null) {
      _subcategoriaDao.save(entidade);
    }
  }

  @override
  Future<Subcategoria> ler(int id) async {
    return _subcategoriaDao.findById(id);
  }

  @override
  Future<List<Subcategoria>> listar() async {
    return _subcategoriaDao.findAllByCategoriaPaiInOrderByCategoriaPai_OrdemAscDescricao(await _categoriaService.listar());
  }

  @override
  Future<Page<Subcategoria>> listarPagina(Pageable pagina) async {
    // TODO Como paginar esta página?
    return null;
  }

  @override
  Future<List<Subcategoria>> listarReceitas() async {
    return _subcategoriaDao.findAllByCategoriaPaiInOrderByCategoriaPai_OrdemAscDescricao(await _categoriaService.listarReceitas());
  }

  @override
  Future<List<Subcategoria>> listarDespesas() async {
    return _subcategoriaDao.findAllByCategoriaPaiInOrderByCategoriaPai_OrdemAscDescricao(await _categoriaService.listarDespesas());
  }

  @override
  Future<int> contagem() async {
    return _subcategoriaDao.countByCategoriaPaiIn(await _categoriaService.listar());
  }

  @override
  void editar(Subcategoria entidade) {
    _subcategoriaDao.save(entidade);
  }

  @override
  void excluir(Subcategoria entidade) {
    _subcategoriaDao.delete(entidade);
  }

  @override
  void validar(Subcategoria entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idSubcategoria == null) {
      // Não pode repetir descrição na mesma categoria Pai
      if (entidade.categoriaPai != null &&
          _subcategoriaDao.existsByDescricaoAndCategoriaPai(entidade.descricao, entidade.categoriaPai)) {
        validacao.rejectValue("descricao", "Unique");
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      // Não pode repetir descrição na mesma categoria Pai
      if (entidade.categoriaPai != null &&
          _subcategoriaDao.existsByDescricaoAndCategoriaPaiAndIdSubcategoriaNot(
              entidade.descricao, entidade.categoriaPai, entidade.idSubcategoria)) {
        validacao.rejectValue("descricao", "Unique");
      }
      // Não pode inverter receitas e despesas
      Subcategoria anterior = await ler(entidade.idSubcategoria);
      if (anterior.categoriaPai.tipo != entidade.categoriaPai.tipo) {
        validacao.rejectValue("categoriaPai", "typeMismatch", [0, "não é do mesmo tipo da anterior"], null);
      }
    }
 @override
void padronizar(Subcategoria entidade) {
  // VALIDAÇÕES EM AMBOS

  // Não pode repetir descrição na mesma categoria Pai
  if (entidade.idSubcategoria == null) {
    if (entidade.categoriaPai != null &&
        _subcategoriaDao.existsByDescricaoAndCategoriaPai(entidade.descricao, entidade.categoriaPai)) {
      validacao.rejectValue("descricao", "Unique");
    }
  } else {
    if (entidade.categoriaPai != null &&
        _subcategoriaDao.existsByDescricaoAndCategoriaPaiAndIdSubcategoriaNot(
            entidade.descricao, entidade.categoriaPai, entidade.idSubcategoria)) {
      validacao.rejectValue("descricao", "Unique");
    }
  }

  // Não pode inverter receitas e despesas
  if (entidade.idSubcategoria != null) {
    Subcategoria anterior = await ler(entidade.idSubcategoria);
    if (anterior.categoriaPai.tipo != entidade.categoriaPai.tipo) {
      validacao.rejectValue("categoriaPai", "typeMismatch", [0, "não é do mesmo tipo da anterior"], null);
    }
  }
}

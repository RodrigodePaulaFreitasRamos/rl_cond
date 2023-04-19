import 'package:flutter/cupertino.dart';
import 'package:app_condominio/dao/pessoa_dao.dart';
import 'package:app_condominio/dao/pessoa_fisica_dao.dart';
import 'package:app_condominio/dao/pessoa_juridica_dao.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/domain/moradia.dart';
import 'package:app_condominio/domain/pessoa.dart';
import 'package:app_condominio/domain/pessoa_fisica.dart';
import 'package:app_condominio/domain/pessoa_juridica.dart';
import 'package:app_condominio/domain/relacao.dart';
import 'package:app_condominio/domain/enums/tipo_relacao.dart';
import 'package:app_condominio/service/usuario_service.dart';

class PessoaServiceImpl implements PessoaService {
  PessoaDao pessoaDao;
  PessoaFisicaDao pessoaFisicaDao;
  PessoaJuridicaDao pessoaJuridicaDao;
  UsuarioService usuarioService;

  PessoaServiceImpl({
    required this.pessoaDao,
    required this.pessoaFisicaDao,
    required this.pessoaJuridicaDao,
    required this.usuarioService,
  });

  @override
  void salvar(Pessoa entidade) {
    if (entidade.idPessoa == null) {
      padronizar(entidade);
      pessoaDao.save(entidade);
    }
  }

  @override
  Pessoa ler(int id) {
    return pessoaDao.findById(id).get();
  }

  @override
  List<Pessoa> listar() {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return <Pessoa>[];
    }
    return condominio.pessoas;
  }

  @override
  Page<Pessoa> listarPagina(Pageable pagina) {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return Page.empty(pagina);
    }
    return pessoaDao.findAllByCondominioOrderByNome(condominio, pagina);
  }

  @override
  void editar(Pessoa entidade) {
    padronizar(entidade);
    pessoaDao.save(entidade);
  }

  @override
  void excluir(Pessoa entidade) {
    pessoaDao.delete(entidade);
  }

  @override
  void validar(Pessoa entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idPessoa == null) {
      if (entidade is PessoaFisica) {
        if (entidade.cpf != null &&
            pessoaFisicaDao.existsByCpfAndCondominio(
                entidade.cpf, usuarioService.lerLogado().condominio)) {
          validacao.rejectValue("cpf", "Unique");
        }
      } else if (entidade is PessoaJuridica) {
        if (entidade.cnpj != null &&
            pessoaJuridicaDao.existsByCnpjAndCondominio(
                entidade.cnpj, usuarioService.lerLogado().condominio)) {
          validacao.rejectValue("cnpj", "Unique");
        }
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
    else {
      if (entidade instanceof PessoaFisica) {
        if (entidade.getCpf() != null &&
            pessoaFisicaDao.existsByCpf(entidade.getCpf())) {
          throw new ValidacaoException("CPF já cadastrado");
        }
      }
    }
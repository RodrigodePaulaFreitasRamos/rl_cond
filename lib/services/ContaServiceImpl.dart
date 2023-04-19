import 'package:app_condominio/dao/conta_dao.dart';
import 'package:app_condominio/domain/condominio.dart';
import 'package:app_condominio/domain/conta.dart';
import 'package:app_condominio/service/conta_service.dart';
import 'package:app_condominio/service/usuario_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:org_springframework/beans/factory/annotation/autowired.dart';
import 'package:org_springframework/data/domain/page.dart';
import 'package:org_springframework/data/domain/pageable.dart';
import 'package:org_springframework/stereotype/service.dart';
import 'package:org_springframework/transaction/annotation/transactional.dart';
import 'package:org_springframework/transaction/annotation/transactional.dart';
import 'package:org_springframework/validation/binding_result.dart';

@Service
@Transactional
class ContaServiceImpl implements ContaService {
  
  @Autowired
  ContaDao contaDao;
  
  @Autowired
  UsuarioService usuarioService;
  
  @override
  void salvar(Conta entidade) {
    if (entidade.idConta == null) {
      padronizar(entidade);
      // LATER fazer esta alteração com trigger
      entidade.saldoAtual = entidade.saldoInicial;
      contaDao.save(entidade);
    }
  }
  
  @override
  @transactional(readOnly: true, propagation: Propagation.SUPPORTS)
  Conta ler(int id) {
    return contaDao.findById(id).get();
  }
  
  @override
  @transactional(readOnly: true, propagation: Propagation.SUPPORTS)
  List<Conta> listar() {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return <Conta>[];
    }
    return condominio.contas;
  }
  
  @override
  Page<Conta> listarPagina(Pageable pagina) {
    Condominio condominio = usuarioService.lerLogado().condominio;
    if (condominio == null) {
      return Page.empty(pagina);
    }
    return contaDao.findAllByCondominioOrderBySiglaAsc(condominio, pagina);
  }
  
  @override
  void editar(Conta entidade) {
    padronizar(entidade);
    // LATER fazer esta alteração com trigger
    Conta antiga = ler(entidade.idConta);
    entidade.saldoAtual = antiga.saldoAtual.subtract(antiga.saldoInicial).add(entidade.saldoInicial);
    contaDao.save(entidade);
  }
  
  @override
  void excluir(Conta entidade) {
    contaDao.delete(entidade);
  }
  
  @override
  @transactional(readOnly: true, propagation: Propagation.SUPPORTS)
  void validar(Conta entidade, BindingResult validacao) {
    // VALIDAÇÕES NA INCLUSÃO
    if (entidade.idConta == null) {
      // Sigla não pode repetir
      if (contaDao.existsBySiglaAndCondominio(entidade.sigla, usuarioService.lerLogado().condominio)) {
        validacao.rejectValue('sigla', 'Unique');
      }
    }
    // VALIDAÇÕES NA ALTERAÇÃO
else {
  // Sigla não pode repetir
  if (await contaDao.existsBySiglaAndCondominioAndIdContaNot(
      entidade.sigla,
      usuarioService.lerLogado().getCondominio(),
      entidade.idConta)) {
    validacao.rejectValue("sigla", "Unique");
  }
}

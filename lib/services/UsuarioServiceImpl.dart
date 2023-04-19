Aqui está o código convertido para a linguagem Dart:

import 'package:app_condominio/dao/usuario_dao.dart';
import 'package:app_condominio/domain/usuario.dart';
import 'package:app_condominio/domain/enums/autorizacao.dart';
import 'package:app_condominio/service/email_service.dart';
import 'package:app_condominio/service/usuario_service.dart';
import 'package:app_condominio/validation/usuario_validacao.dart';
import 'package:flutter.security.dart';

class UsuarioServiceImpl implements UsuarioService {
  UsuarioDao _usuarioDao;
  EmailService _emailService;
  PasswordEncoder _passwordEncoder;

  UsuarioServiceImpl(UsuarioDao usuarioDao, EmailService emailService, PasswordEncoder passwordEncoder) {
    this._usuarioDao = usuarioDao;
    this._emailService = emailService;
    this._passwordEncoder = passwordEncoder;
  }

  @override
  void salvar(Usuario usuario) {
    if (usuario.id == null) {
      usuario.password = _passwordEncoder.encode(usuario.password);
      _usuarioDao.save(usuario);
    }
  }

  @override
  Usuario ler(String username) {
    return _usuarioDao.findOneByUsername(username);
  }

  @override
  Usuario lerPorId(int id) {
    return _usuarioDao.findById(id).get();
  }

  @override
  Usuario lerLogado() {
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    if (auth == null || auth.getAuthorities().contains(new SimpleGrantedAuthority('ROLE_ANONYMOUS'))) {
      return null;
    }
    return _usuarioDao.findOneByUsername(auth.getName());
  }

  @override
  void editar(Usuario usuario) {
    if (!usuario.password.startsWith('{bcrypt}')) {
      usuario.password = _passwordEncoder.encode(usuario.password);
    }
    if (usuario.autorizacoes.isEmpty) {
      usuario.autorizacoes = lerPorId(usuario.id).autorizacoes;
    }
    _usuarioDao.save(usuario);
  }

  @override
  void excluir(Usuario usuario) {
    _usuarioDao.delete(usuario);
  }

  @override
  void salvarSindico(Usuario usuario) {
    usuario.autorizacoes.add(Autorizacao.SINDICO);
    salvar(usuario);
  }

  @override
  void salvarCondomino(Usuario usuario) {
    usuario.autorizacoes.add(Autorizacao.CONDOMINO);
    salvar(usuario);
  }

  @override
  void salvarAdmin(Usuario usuario) {
    usuario.autorizacoes.add(Autorizacao.ADMIN);
    salvar(usuario);
  }

  @override
  bool redefinirSenha(String username) {
    Usuario usuario = ler(username);
    if (usuario != null) {
      String para = usuario.email;
      String assunto = 'Condomínio App - Redefinição de Senha';
      String mensagem = 'Acesse o endereço abaixo para redefinir sua senha:\n\nhttp://localhost:8080/conta/redefinir?username=' +
          usuario.username +
          '&token=' +
          getToken(usuario.password) +
          '\n\nCaso não consiga clicar no link acima, copie-o e cole em seu navegador.' +
          '\n\nPor segurança este link só é válido até o final do dia.';
      _emailService.enviarEmail(para, assunto, mensagem);
      return true;
    } else {
      return false;
    }
  }

  @override
bool redefinirSenhaComToken(String username, String token, String password) {
Usuario usuario = _usuarioDao.findOneByUsername(username);
if (usuario != null && getToken(usuario.password) == token) {
usuario.password = password;
_usuarioDao.update(usuario);
return true;
}
return false;
}
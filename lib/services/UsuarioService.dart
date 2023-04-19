import 'package:app_condominio/domain/usuario.dart';
import 'package:app_condominio/service/crud_service.dart';

abstract class UsuarioService extends CrudService<Usuario, int> {
  void salvarSindico(Usuario usuario);
  void salvarCondomino(Usuario usuario);
  void salvarAdmin(Usuario usuario);
  Usuario ler(String username);
  Usuario lerLogado();
  bool redefinirSenha(String username);
  bool redefinirSenha(String username, String token, String password);
}

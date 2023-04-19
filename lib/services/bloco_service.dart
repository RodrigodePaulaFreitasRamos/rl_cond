import 'package:app_condominio/domain/bloco.dart'; // Importe a classe de domínio Bloco

abstract class BlocoService {
  Future<Bloco> getById(int id); // Defina os métodos do serviço, por exemplo getById
  Future<List<Bloco>> getAll();
  Future<void> save(Bloco bloco);
  Future<void> update(Bloco bloco);
  Future<void> delete(int id);
}

class CrudBlocoService implements BlocoService {
  @override
  Future<Bloco> getById(int id) async {
    // Implemente a lógica para obter um Bloco por ID
  }

  @override
  Future<List<Bloco>> getAll() async {
    // Implemente a lógica para obter todos os Blocos
  }

  @override
  Future<void> save(Bloco bloco) async {
    // Implemente a lógica para salvar um Bloco
  }

  @override
  Future<void> update(Bloco bloco) async {
    // Implemente a lógica para atualizar um Bloco
  }

  @override
  Future<void> delete(int id) async {
    // Implemente a lógica para deletar um Bloco por ID
  }
}

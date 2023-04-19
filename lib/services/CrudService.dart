import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrudService<C, T> {
  void salvar(C entidade) {
    // Lógica de salvamento no banco de dados
  }

  C ler(T id) {
    // Lógica de leitura do banco de dados
    return null;
  }

  List<C> listar() {
    // Lógica de listagem do banco de dados
    return [];
  }

  Page<C> listarPagina(Pageable pagina) {
    // Lógica de listagem paginada do banco de dados
    return Page<C>();
  }

  void editar(C entidade) {
    // Lógica de edição no banco de dados
  }

  void excluir(C entidade) {
    // Lógica de exclusão no banco de dados
  }

  void validar(C entidade, BindingResult validacao) {
    // Lógica de validação da entidade
  }

  void padronizar(C entidade) {
    // Lógica de padronização dos atributos da entidade
  }
}

import 'package:app_condominio/domain/subcategoria.dart';

abstract class SubcategoriaService {
  Future<int> contagem();

  Future<List<Subcategoria>> listarReceitas();

  Future<List<Subcategoria>> listarDespesas();
}

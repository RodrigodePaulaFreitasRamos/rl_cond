import 'package:app_condominio/domain/categoria.dart';

abstract class CategoriaService extends CrudService<Categoria, int> {
  
  List<Categoria> listarReceitas();
  
  List<Categoria> listarDespesas();
}

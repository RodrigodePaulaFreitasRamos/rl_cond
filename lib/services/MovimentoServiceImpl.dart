import 'package:app_condominio/domain/categoria.dart';
import 'package:app_condominio/domain/orcamento.dart';
import 'package:app_condominio/domain/periodo.dart';
import 'package:app_condominio/domain/subcategoria.dart';
import 'package:app_condominio/domain/enums/tipo_categoria.dart';

abstract class OrcamentoService implements CrudService<Orcamento, int> {

  BigDecimal somaOrcamentos(Periodo periodo, TipoCategoria tipo);

  BigDecimal somaOrcamentos(Periodo periodo, Categoria categoria);

  Orcamento ler(Periodo periodo, Subcategoria subcategoria);

}
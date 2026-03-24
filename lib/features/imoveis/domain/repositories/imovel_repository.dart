import '../entities/imovel_entity.dart';

abstract class ImovelRepository {
  Future<List<ImovelEntity>> getAll();
  Future<ImovelEntity?> getById(int id);
  Future<void> save(ImovelEntity imovel);
  Future<void> create(ImovelEntity imovel);
  Future<void> delete(int id);
}

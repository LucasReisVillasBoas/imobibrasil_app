import '../../domain/entities/imovel_entity.dart';
import '../../domain/repositories/imovel_repository.dart';
import '../datasources/imovel_local_datasource.dart';
import '../models/imovel_model.dart';

class ImovelRepositoryImpl implements ImovelRepository {
  final ImovelLocalDataSource dataSource;

  const ImovelRepositoryImpl({required this.dataSource});

  @override
  Future<List<ImovelEntity>> getAll() async {
    final models = await dataSource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ImovelEntity?> getById(int id) async {
    final all = await getAll();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(ImovelEntity imovel) async {
    final all = await dataSource.getAll();
    final index = all.indexWhere((m) => m.id == imovel.id);
    if (index != -1) {
      all[index] = ImovelModel.fromEntity(imovel);
      await dataSource.saveAll(all);
    }
  }

  @override
  Future<void> create(ImovelEntity imovel) async {
    final all = await dataSource.getAll();
    final newId = all.isEmpty
        ? 1
        : all.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final newModel = ImovelModel.fromEntity(
      imovel.copyWith(id: newId),
    );
    all.add(newModel);
    await dataSource.saveAll(all);
  }

  @override
  Future<void> delete(int id) async {
    final all = await dataSource.getAll();
    all.removeWhere((m) => m.id == id);
    await dataSource.saveAll(all);
  }
}

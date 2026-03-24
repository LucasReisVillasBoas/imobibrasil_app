import '../entities/imovel_entity.dart';
import '../repositories/imovel_repository.dart';

class GetImoveisUseCase {
  final ImovelRepository repository;
  const GetImoveisUseCase(this.repository);

  Future<List<ImovelEntity>> call() => repository.getAll();
}

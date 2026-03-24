import '../entities/imovel_entity.dart';
import '../repositories/imovel_repository.dart';

class GetImovelByIdUseCase {
  final ImovelRepository repository;
  const GetImovelByIdUseCase(this.repository);

  Future<ImovelEntity?> call(int id) => repository.getById(id);
}

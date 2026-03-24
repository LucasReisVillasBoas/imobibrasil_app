import '../entities/imovel_entity.dart';
import '../repositories/imovel_repository.dart';

class CreateImovelUseCase {
  final ImovelRepository repository;
  const CreateImovelUseCase(this.repository);

  Future<void> call(ImovelEntity imovel) => repository.create(imovel);
}

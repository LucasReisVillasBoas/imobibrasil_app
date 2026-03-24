import '../entities/imovel_entity.dart';
import '../repositories/imovel_repository.dart';

class SaveImovelUseCase {
  final ImovelRepository repository;
  const SaveImovelUseCase(this.repository);

  Future<void> call(ImovelEntity imovel) => repository.save(imovel);
}

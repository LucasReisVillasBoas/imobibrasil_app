import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/imovel_local_datasource.dart';
import '../../data/repositories/imovel_repository_impl.dart';
import '../../domain/entities/imovel_entity.dart';
import '../../domain/repositories/imovel_repository.dart';
import '../../domain/usecases/get_imoveis_usecase.dart';
import '../../domain/usecases/get_imovel_by_id_usecase.dart';
import '../../domain/usecases/save_imovel_usecase.dart';
import '../../domain/usecases/create_imovel_usecase.dart';

// ---------- Infraestrutura ----------

final imovelDataSourceProvider = Provider<ImovelLocalDataSource>((ref) {
  return ImovelLocalDataSource();
});

final imovelRepositoryProvider = Provider<ImovelRepository>((ref) {
  return ImovelRepositoryImpl(
    dataSource: ref.read(imovelDataSourceProvider),
  );
});

// ---------- Use Cases ----------

final getImoveisUseCaseProvider = Provider<GetImoveisUseCase>((ref) {
  return GetImoveisUseCase(ref.read(imovelRepositoryProvider));
});

final getImovelByIdUseCaseProvider = Provider<GetImovelByIdUseCase>((ref) {
  return GetImovelByIdUseCase(ref.read(imovelRepositoryProvider));
});

final saveImovelUseCaseProvider = Provider<SaveImovelUseCase>((ref) {
  return SaveImovelUseCase(ref.read(imovelRepositoryProvider));
});

final createImovelUseCaseProvider = Provider<CreateImovelUseCase>((ref) {
  return CreateImovelUseCase(ref.read(imovelRepositoryProvider));
});

// ---------- Estado da lista ----------

class ImoveisNotifier extends AsyncNotifier<List<ImovelEntity>> {
  @override
  Future<List<ImovelEntity>> build() async {
    return ref.read(getImoveisUseCaseProvider).call();
  }

  Future<void> saveImovel(ImovelEntity imovel) async {
    await ref.read(saveImovelUseCaseProvider).call(imovel);
    ref.invalidateSelf();
    await future;
  }

  Future<void> createImovel(ImovelEntity imovel) async {
    await ref.read(createImovelUseCaseProvider).call(imovel);
    ref.invalidateSelf();
    await future;
  }
}

final imoveisNotifierProvider =
    AsyncNotifierProvider<ImoveisNotifier, List<ImovelEntity>>(
  ImoveisNotifier.new,
);

// ---------- Filtros ----------

enum TipoFiltro { todos, venda, aluguel }

class FilterState {
  final TipoFiltro tipo;
  final String query;

  const FilterState({
    this.tipo = TipoFiltro.todos,
    this.query = '',
  });

  FilterState copyWith({TipoFiltro? tipo, String? query}) {
    return FilterState(
      tipo: tipo ?? this.tipo,
      query: query ?? this.query,
    );
  }
}

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => const FilterState();

  void setTipo(TipoFiltro tipo) => state = state.copyWith(tipo: tipo);
  void setQuery(String query) => state = state.copyWith(query: query);
  void reset() => state = const FilterState();
}

final filterNotifierProvider =
    NotifierProvider<FilterNotifier, FilterState>(FilterNotifier.new);

// ---------- Lista filtrada (derivada) ----------

final imoveisFilteredProvider =
    Provider<AsyncValue<List<ImovelEntity>>>((ref) {
  final imoveisAsync = ref.watch(imoveisNotifierProvider);
  final filter = ref.watch(filterNotifierProvider);

  return imoveisAsync.whenData((imoveis) {
    var result = imoveis;

    if (filter.tipo != TipoFiltro.todos) {
      result = result.where((i) => i.tipo == filter.tipo.name).toList();
    }

    if (filter.query.isNotEmpty) {
      final q = filter.query.toLowerCase();
      result = result
          .where((i) =>
              i.titulo.toLowerCase().contains(q) ||
              i.cidade.toLowerCase().contains(q) ||
              i.bairro.toLowerCase().contains(q))
          .toList();
    }

    return result;
  });
});

// ---------- Imóvel selecionado ----------

final selectedImovelProvider =
    Provider.family<AsyncValue<ImovelEntity?>, int>((ref, id) {
  final imoveisAsync = ref.watch(imoveisNotifierProvider);
  return imoveisAsync.whenData(
    (list) => list.where((i) => i.id == id).firstOrNull,
  );
});

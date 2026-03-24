import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/imovel_entity.dart';

class ImovelFormState {
  final String titulo;
  final String descricao;
  final String tipo;
  final String preco;
  final String cidade;
  final String bairro;
  final String quartos;
  final String banheiros;
  final String vagas;
  final String areaM2;
  final bool isLoading;
  final String? errorMessage;

  const ImovelFormState({
    this.titulo = '',
    this.descricao = '',
    this.tipo = 'venda',
    this.preco = '',
    this.cidade = '',
    this.bairro = '',
    this.quartos = '',
    this.banheiros = '',
    this.vagas = '',
    this.areaM2 = '',
    this.isLoading = false,
    this.errorMessage,
  });

  factory ImovelFormState.fromEntity(ImovelEntity entity) {
    return ImovelFormState(
      titulo: entity.titulo,
      descricao: entity.descricao,
      tipo: entity.tipo,
      preco: entity.preco.toString(),
      cidade: entity.cidade,
      bairro: entity.bairro,
      quartos: entity.quartos.toString(),
      banheiros: entity.banheiros.toString(),
      vagas: entity.vagas.toString(),
      areaM2: entity.areaM2.toString(),
    );
  }

  ImovelFormState copyWith({
    String? titulo,
    String? descricao,
    String? tipo,
    String? preco,
    String? cidade,
    String? bairro,
    String? quartos,
    String? banheiros,
    String? vagas,
    String? areaM2,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ImovelFormState(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      preco: preco ?? this.preco,
      cidade: cidade ?? this.cidade,
      bairro: bairro ?? this.bairro,
      quartos: quartos ?? this.quartos,
      banheiros: banheiros ?? this.banheiros,
      vagas: vagas ?? this.vagas,
      areaM2: areaM2 ?? this.areaM2,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  ImovelEntity toEntity({int id = 0, String foto = ''}) {
    return ImovelEntity(
      id: id,
      titulo: titulo,
      descricao: descricao,
      tipo: tipo,
      preco: double.tryParse(preco.replaceAll(',', '.')) ?? 0,
      cidade: cidade,
      bairro: bairro,
      quartos: int.tryParse(quartos) ?? 0,
      banheiros: int.tryParse(banheiros) ?? 0,
      vagas: int.tryParse(vagas) ?? 0,
      areaM2: double.tryParse(areaM2.replaceAll(',', '.')) ?? 0,
      foto: foto,
    );
  }

  bool get isValid {
    final precoVal = double.tryParse(preco.replaceAll(',', '.')) ?? 0;
    final areaVal = double.tryParse(areaM2.replaceAll(',', '.')) ?? 0;
    return titulo.isNotEmpty &&
        descricao.isNotEmpty &&
        cidade.isNotEmpty &&
        bairro.isNotEmpty &&
        precoVal > 0 &&
        areaVal > 0;
  }
}

class ImovelFormNotifier extends Notifier<ImovelFormState> {
  @override
  ImovelFormState build() => const ImovelFormState();

  void initFromEntity(ImovelEntity entity) {
    state = ImovelFormState.fromEntity(entity);
  }

  void initEmpty() {
    state = const ImovelFormState();
  }

  void setTitulo(String v) => state = state.copyWith(titulo: v);
  void setDescricao(String v) => state = state.copyWith(descricao: v);
  void setTipo(String v) => state = state.copyWith(tipo: v);
  void setPreco(String v) => state = state.copyWith(preco: v);
  void setCidade(String v) => state = state.copyWith(cidade: v);
  void setBairro(String v) => state = state.copyWith(bairro: v);
  void setQuartos(String v) => state = state.copyWith(quartos: v);
  void setBanheiros(String v) => state = state.copyWith(banheiros: v);
  void setVagas(String v) => state = state.copyWith(vagas: v);
  void setAreaM2(String v) => state = state.copyWith(areaM2: v);
  void setLoading(bool v) => state = state.copyWith(isLoading: v);
}

final imovelFormNotifierProvider =
    NotifierProvider<ImovelFormNotifier, ImovelFormState>(
  ImovelFormNotifier.new,
);

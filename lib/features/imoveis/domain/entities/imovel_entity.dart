class ImovelEntity {
  final int id;
  final String titulo;
  final String descricao;
  final String tipo; // 'venda' ou 'aluguel'
  final double preco;
  final String cidade;
  final String bairro;
  final int quartos;
  final int banheiros;
  final int vagas;
  final double areaM2;
  final String foto;

  const ImovelEntity({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.preco,
    required this.cidade,
    required this.bairro,
    required this.quartos,
    required this.banheiros,
    required this.vagas,
    required this.areaM2,
    required this.foto,
  });

  ImovelEntity copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? tipo,
    double? preco,
    String? cidade,
    String? bairro,
    int? quartos,
    int? banheiros,
    int? vagas,
    double? areaM2,
    String? foto,
  }) {
    return ImovelEntity(
      id: id ?? this.id,
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
      foto: foto ?? this.foto,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImovelEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

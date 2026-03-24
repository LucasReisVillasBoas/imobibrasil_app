import '../../domain/entities/imovel_entity.dart';

class ImovelModel {
  final int id;
  final String titulo;
  final String descricao;
  final String tipo;
  final double preco;
  final String cidade;
  final String bairro;
  final int quartos;
  final int banheiros;
  final int vagas;
  final double areaM2;
  final String foto;

  const ImovelModel({
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

  factory ImovelModel.fromJson(Map<String, dynamic> json) => ImovelModel(
        id: json['id'] as int,
        titulo: json['titulo'] as String,
        descricao: json['descricao'] as String,
        tipo: json['tipo'] as String,
        preco: (json['preco'] as num).toDouble(),
        cidade: json['cidade'] as String,
        bairro: json['bairro'] as String,
        quartos: json['quartos'] as int,
        banheiros: json['banheiros'] as int,
        vagas: json['vagas'] as int,
        areaM2: (json['area_m2'] as num).toDouble(),
        foto: json['foto'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'tipo': tipo,
        'preco': preco,
        'cidade': cidade,
        'bairro': bairro,
        'quartos': quartos,
        'banheiros': banheiros,
        'vagas': vagas,
        'area_m2': areaM2,
        'foto': foto,
      };

  factory ImovelModel.fromEntity(ImovelEntity entity) => ImovelModel(
        id: entity.id,
        titulo: entity.titulo,
        descricao: entity.descricao,
        tipo: entity.tipo,
        preco: entity.preco,
        cidade: entity.cidade,
        bairro: entity.bairro,
        quartos: entity.quartos,
        banheiros: entity.banheiros,
        vagas: entity.vagas,
        areaM2: entity.areaM2,
        foto: entity.foto,
      );

  ImovelEntity toEntity() => ImovelEntity(
        id: id,
        titulo: titulo,
        descricao: descricao,
        tipo: tipo,
        preco: preco,
        cidade: cidade,
        bairro: bairro,
        quartos: quartos,
        banheiros: banheiros,
        vagas: vagas,
        areaM2: areaM2,
        foto: foto,
      );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:imobibrasil_app/features/imoveis/data/models/imovel_model.dart';
import 'package:imobibrasil_app/features/imoveis/domain/entities/imovel_entity.dart';

void main() {
  const tJson = {
    'id': 1,
    'titulo': 'Apartamento Centro',
    'descricao': 'Apartamento de 2 quartos',
    'tipo': 'aluguel',
    'preco': 1800.0,
    'cidade': 'Presidente Prudente',
    'bairro': 'Centro',
    'quartos': 2,
    'banheiros': 1,
    'vagas': 1,
    'area_m2': 65,
    'foto': 'https://picsum.photos/seed/apt1/600/400',
  };

  const tModel = ImovelModel(
    id: 1,
    titulo: 'Apartamento Centro',
    descricao: 'Apartamento de 2 quartos',
    tipo: 'aluguel',
    preco: 1800.0,
    cidade: 'Presidente Prudente',
    bairro: 'Centro',
    quartos: 2,
    banheiros: 1,
    vagas: 1,
    areaM2: 65,
    foto: 'https://picsum.photos/seed/apt1/600/400',
  );

  const tEntity = ImovelEntity(
    id: 1,
    titulo: 'Apartamento Centro',
    descricao: 'Apartamento de 2 quartos',
    tipo: 'aluguel',
    preco: 1800.0,
    cidade: 'Presidente Prudente',
    bairro: 'Centro',
    quartos: 2,
    banheiros: 1,
    vagas: 1,
    areaM2: 65,
    foto: 'https://picsum.photos/seed/apt1/600/400',
  );

  group('ImovelModel', () {
    test('fromJson deve criar model corretamente', () {
      final result = ImovelModel.fromJson(tJson);
      expect(result.id, equals(1));
      expect(result.titulo, equals('Apartamento Centro'));
      expect(result.tipo, equals('aluguel'));
      expect(result.preco, equals(1800.0));
      expect(result.areaM2, equals(65.0));
    });

    test('toJson deve serializar corretamente', () {
      final result = tModel.toJson();
      expect(result['id'], equals(1));
      expect(result['tipo'], equals('aluguel'));
      expect(result['area_m2'], equals(65.0));
    });

    test('toEntity deve converter para ImovelEntity corretamente', () {
      final result = tModel.toEntity();
      expect(result.id, equals(tEntity.id));
      expect(result.titulo, equals(tEntity.titulo));
      expect(result.preco, equals(tEntity.preco));
    });

    test('fromEntity deve converter de ImovelEntity corretamente', () {
      final result = ImovelModel.fromEntity(tEntity);
      expect(result.id, equals(tModel.id));
      expect(result.titulo, equals(tModel.titulo));
      expect(result.areaM2, equals(tModel.areaM2));
    });
  });
}

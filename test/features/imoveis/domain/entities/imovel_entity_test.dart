import 'package:flutter_test/flutter_test.dart';
import 'package:imobibrasil_app/features/imoveis/domain/entities/imovel_entity.dart';

void main() {
  const tEntity = ImovelEntity(
    id: 1,
    titulo: 'Apartamento Centro',
    descricao: 'Descrição',
    tipo: 'aluguel',
    preco: 1800.0,
    cidade: 'Presidente Prudente',
    bairro: 'Centro',
    quartos: 2,
    banheiros: 1,
    vagas: 1,
    areaM2: 65,
    foto: 'https://foto.com/1.jpg',
  );

  group('ImovelEntity', () {
    test('copyWith deve atualizar apenas campos fornecidos', () {
      final updated = tEntity.copyWith(titulo: 'Novo Título', preco: 2000.0);
      expect(updated.titulo, equals('Novo Título'));
      expect(updated.preco, equals(2000.0));
      expect(updated.id, equals(tEntity.id));
      expect(updated.cidade, equals(tEntity.cidade));
    });

    test('igualdade deve ser baseada apenas no id', () {
      const other = ImovelEntity(
        id: 1,
        titulo: 'Outro Título',
        descricao: 'Outra descrição',
        tipo: 'venda',
        preco: 9999.0,
        cidade: 'Outra Cidade',
        bairro: 'Outro Bairro',
        quartos: 5,
        banheiros: 5,
        vagas: 5,
        areaM2: 999,
        foto: 'https://outra.com',
      );
      expect(tEntity, equals(other));
      expect(tEntity.hashCode, equals(other.hashCode));
    });

    test('ids diferentes devem ser entidades diferentes', () {
      final other = tEntity.copyWith(id: 2);
      expect(tEntity, isNot(equals(other)));
    });
  });
}

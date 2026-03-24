import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imobibrasil_app/features/imoveis/presentation/providers/imovel_form_provider.dart';
import 'package:imobibrasil_app/features/imoveis/domain/entities/imovel_entity.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('ImovelFormNotifier', () {
    test('estado inicial deve ser vazio', () {
      final state = container.read(imovelFormNotifierProvider);
      expect(state.titulo, isEmpty);
      expect(state.tipo, equals('venda'));
      expect(state.isLoading, isFalse);
    });

    test('setTitulo deve atualizar titulo', () {
      container
          .read(imovelFormNotifierProvider.notifier)
          .setTitulo('Casa Nova');
      final state = container.read(imovelFormNotifierProvider);
      expect(state.titulo, equals('Casa Nova'));
    });

    test('setTipo deve atualizar tipo', () {
      container.read(imovelFormNotifierProvider.notifier).setTipo('aluguel');
      final state = container.read(imovelFormNotifierProvider);
      expect(state.tipo, equals('aluguel'));
    });

    test('isValid deve ser false com campos vazios', () {
      final state = container.read(imovelFormNotifierProvider);
      expect(state.isValid, isFalse);
    });

    test('isValid deve ser true com todos campos preenchidos', () {
      final notifier = container.read(imovelFormNotifierProvider.notifier);
      notifier.setTitulo('Casa');
      notifier.setDescricao('Descrição');
      notifier.setCidade('Cidade');
      notifier.setBairro('Bairro');
      notifier.setPreco('1800.00');
      notifier.setAreaM2('65');
      final state = container.read(imovelFormNotifierProvider);
      expect(state.isValid, isTrue);
    });

    test('initFromEntity deve preencher todos os campos', () {
      const entity = ImovelEntity(
        id: 1,
        titulo: 'Apto Teste',
        descricao: 'Desc Teste',
        tipo: 'aluguel',
        preco: 1500.0,
        cidade: 'Cidade Teste',
        bairro: 'Bairro Teste',
        quartos: 2,
        banheiros: 1,
        vagas: 1,
        areaM2: 50,
        foto: 'https://foto.com',
      );
      container
          .read(imovelFormNotifierProvider.notifier)
          .initFromEntity(entity);
      final state = container.read(imovelFormNotifierProvider);
      expect(state.titulo, equals('Apto Teste'));
      expect(state.tipo, equals('aluguel'));
      expect(state.cidade, equals('Cidade Teste'));
    });

    test('toEntity deve converter corretamente', () {
      final notifier = container.read(imovelFormNotifierProvider.notifier);
      notifier.setTitulo('Casa');
      notifier.setDescricao('Desc');
      notifier.setTipo('venda');
      notifier.setPreco('350000');
      notifier.setCidade('PP');
      notifier.setBairro('Centro');
      notifier.setQuartos('3');
      notifier.setBanheiros('2');
      notifier.setVagas('2');
      notifier.setAreaM2('150');
      final state = container.read(imovelFormNotifierProvider);
      final entity = state.toEntity(id: 99, foto: 'https://foto.com');
      expect(entity.id, equals(99));
      expect(entity.titulo, equals('Casa'));
      expect(entity.preco, equals(350000.0));
      expect(entity.tipo, equals('venda'));
    });
  });
}

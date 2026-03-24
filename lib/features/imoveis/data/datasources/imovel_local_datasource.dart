import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/imovel_model.dart';

const String kImoveisBox = 'imoveis_box';
const String kImoveisKey = 'imoveis_data';

class ImovelLocalDataSource {
  Future<List<ImovelModel>> getAll() async {
    // Tenta carregar do Hive primeiro
    final box = await Hive.openBox<dynamic>(kImoveisBox);
    final cached = box.get(kImoveisKey);

    if (cached != null) {
      final list = (cached as List)
          .map((e) => ImovelModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return list;
    }

    // Fallback: carrega do asset com delay simulado
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    final jsonStr = await rootBundle.loadString('assets/data/imoveis.json');
    final jsonData = json.decode(jsonStr) as Map<String, dynamic>;
    final imoveis = (jsonData['imoveis'] as List)
        .map((e) => ImovelModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Salva no Hive para próximas chamadas
    await box.put(kImoveisKey, imoveis.map((e) => e.toJson()).toList());

    return imoveis;
  }

  Future<void> saveAll(List<ImovelModel> imoveis) async {
    final box = await Hive.openBox<dynamic>(kImoveisBox);
    await box.put(kImoveisKey, imoveis.map((e) => e.toJson()).toList());
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox<dynamic>(kImoveisBox);
    await box.delete(kImoveisKey);
  }
}

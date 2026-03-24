import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<void> logLogin() =>
      _analytics.logLogin(loginMethod: 'email');

  static Future<void> logLogout() =>
      _analytics.logEvent(name: 'logout');

  static Future<void> logLoginFailed() =>
      _analytics.logEvent(name: 'login_failed');

  // ── Lista ─────────────────────────────────────────────────────────────────

  static Future<void> logListLoaded({required int count}) =>
      _analytics.logEvent(
        name: 'list_loaded',
        parameters: {'count': count},
      );

  static Future<void> logSearch({required String query}) =>
      _analytics.logSearch(searchTerm: query);

  static Future<void> logFilterApplied({required String filter}) =>
      _analytics.logEvent(
        name: 'filter_applied',
        parameters: {'filter': filter},
      );

  static Future<void> logPullToRefresh() =>
      _analytics.logEvent(name: 'pull_to_refresh');

  // ── Detalhe ───────────────────────────────────────────────────────────────

  static Future<void> logImovelViewed({
    required int imovelId,
    required String titulo,
    required double preco,
    required String tipo,
    String? cidade,
    String? bairro,
  }) =>
      _analytics.logViewItem(
        currency: 'BRL',
        value: preco,
        items: [
          AnalyticsEventItem(
            itemId: '$imovelId',
            itemName: titulo,
            itemCategory: tipo,
            itemVariant: bairro != null && cidade != null ? '$bairro, $cidade' : null,
            price: preco,
          ),
        ],
      );

  static Future<void> logContactRequested({
    required int imovelId,
    required String titulo,
    String? tipo,
    double? preco,
  }) =>
      _analytics.logEvent(
        name: 'contact_requested',
        parameters: {
          'imovel_id': imovelId,
          'titulo': titulo,
          if (tipo != null) 'tipo': tipo,
          if (preco != null) 'preco': preco,
        },
      );

  static Future<void> logEditStarted({required int imovelId}) =>
      _analytics.logEvent(
        name: 'edit_started',
        parameters: {'imovel_id': imovelId},
      );

  // ── Formulário ────────────────────────────────────────────────────────────

  static Future<void> logNewImovelStarted() =>
      _analytics.logEvent(name: 'new_imovel_started');

  static Future<void> logImovelCreated({
    required String tipo,
    required double preco,
    required String cidade,
  }) =>
      _analytics.logEvent(
        name: 'imovel_created',
        parameters: {'tipo': tipo, 'preco': preco, 'cidade': cidade},
      );

  static Future<void> logImovelEdited({
    required int imovelId,
    required String tipo,
    required double preco,
  }) =>
      _analytics.logEvent(
        name: 'imovel_edited',
        parameters: {'imovel_id': imovelId, 'tipo': tipo, 'preco': preco},
      );

  static Future<void> logFormCancelled({required bool isEditing}) =>
      _analytics.logEvent(
        name: 'form_cancelled',
        parameters: {'mode': isEditing ? 'edit' : 'create'},
      );

  // ── Navegação ─────────────────────────────────────────────────────────────

  static Future<void> logScreenView({required String screenName}) =>
      _analytics.logScreenView(screenName: screenName);
}

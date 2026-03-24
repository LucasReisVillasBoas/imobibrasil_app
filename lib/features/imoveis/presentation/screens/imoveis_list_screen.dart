import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../../core/analytics/analytics_service.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors_scheme.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/imovel_entity.dart';
import '../providers/imovel_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/imovel_shimmer.dart';

class ImoveisListScreen extends ConsumerStatefulWidget {
  const ImoveisListScreen({super.key});

  @override
  ConsumerState<ImoveisListScreen> createState() => _ImoveisListScreenState();
}

class _ImoveisListScreenState extends ConsumerState<ImoveisListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(imoveisFilteredProvider);
    final filter = ref.watch(filterNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final userName = authState.user?.name ?? '';

    return Scaffold(
      backgroundColor: context.colors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, userName),
      floatingActionButton: _buildFAB(context),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + 20),
          _buildSearchBar(),
          _buildFilterChips(filter),
          Expanded(
            child: filteredAsync.when(
              loading: () => const ImovelShimmer(),
              error: (e, _) => EmptyState(
                icon: Icons.wifi_off_rounded,
                title: 'Erro ao carregar',
                subtitle: 'Não foi possível carregar os imóveis.',
                actionLabel: 'Tentar novamente',
                onAction: () => ref.invalidate(imoveisNotifierProvider),
              ),
              data: (imoveis) => imoveis.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Nenhum imóvel encontrado',
                      subtitle: filter.query.isNotEmpty
                          ? 'Tente outros termos de busca.'
                          : 'Não há imóveis para este filtro.',
                      actionLabel: 'Limpar filtros',
                      onAction: () {
                        ref.read(filterNotifierProvider.notifier).reset();
                        _searchController.clear();
                      },
                    )
                  : _buildList(imoveis),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String userName) {
    final colors = context.colors;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: colors.appBarBackground,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20,
              right: 12,
              bottom: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.bioElectricGradient,
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty
                          ? userName.substring(0, 1).toUpperCase()
                          : 'C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Olá, ${userName.split(' ').first}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.bioElectricGradient.createShader(bounds),
                        child: const Text(
                          'ImobiBrasil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Pres. Prudente',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.logout_rounded,
                      color: colors.textSecondary, size: 20),
                  onPressed: () async {
                    await AnalyticsService.logLogout();
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search_rounded,
                color: AppColors.outline, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) {
                  ref.read(filterNotifierProvider.notifier).setQuery(v);
                  if (v.length >= 3) AnalyticsService.logSearch(query: v);
                  setState(() {});
                },
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Encontre seu novo lar...',
                  hintStyle: TextStyle(
                    color: context.colors.outline,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded,
                    color: AppColors.outline, size: 18),
                onPressed: () {
                  _searchController.clear();
                  ref.read(filterNotifierProvider.notifier).setQuery('');
                  setState(() {});
                },
              )
            else
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.bioElectricGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildFilterChips(FilterState filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _FilterChip(
            label: 'Todos',
            selected: filter.tipo == TipoFiltro.todos,
            onSelected: (_) {
              ref
                  .read(filterNotifierProvider.notifier)
                  .setTipo(TipoFiltro.todos);
              AnalyticsService.logFilterApplied(filter: 'todos');
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Venda',
            selected: filter.tipo == TipoFiltro.venda,
            onSelected: (_) {
              ref
                  .read(filterNotifierProvider.notifier)
                  .setTipo(TipoFiltro.venda);
              AnalyticsService.logFilterApplied(filter: 'venda');
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Aluguel',
            selected: filter.tipo == TipoFiltro.aluguel,
            onSelected: (_) {
              ref
                  .read(filterNotifierProvider.notifier)
                  .setTipo(TipoFiltro.aluguel);
              AnalyticsService.logFilterApplied(filter: 'aluguel');
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildList(List<ImovelEntity> imoveis) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        AnalyticsService.logPullToRefresh();
        ref.invalidate(imoveisNotifierProvider);
        await ref.read(imoveisNotifierProvider.future);
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: imoveis.length,
        itemBuilder: (context, index) {
          final imovel = imoveis[index];
          return _PremiumImovelCard(
            imovel: imovel,
            index: index,
            onTap: () => context.push(AppRoutes.detailPath(imovel.id)),
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.bioElectricGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            AnalyticsService.logNewImovelStarted();
            context.push(AppRoutes.imovelNew);
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
          ),
        ),
      ),
    ).animate().scale(delay: 600.ms, duration: 400.ms);
  }
}

// ── Card Premium ──────────────────────────────────────────────────────────────

class _PremiumImovelCard extends StatelessWidget {
  final ImovelEntity imovel;
  final VoidCallback onTap;
  final int index;

  const _PremiumImovelCard({
    required this.imovel,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isVenda = imovel.tipo == 'venda';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(isVenda),
              _buildInfo(context),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 80).ms, duration: 400.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _buildImage(bool isVenda) {
    return Stack(
      children: [
        Hero(
          tag: 'imovel-foto-${imovel.id}',
          child: CachedNetworkImage(
            imageUrl: imovel.foto,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: 200,
              color: AppColors.surfaceContainerHigh,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              height: 200,
              color: AppColors.surfaceContainerHigh,
              child:
                  const Icon(Icons.home_outlined, size: 48, color: Colors.grey),
            ),
          ),
        ),
        // Gradiente escuro na parte inferior da imagem
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Badge tipo
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: isVenda
                  ? const LinearGradient(
                      colors: [Color(0xFF004FA9), Color(0xFF0067D8)],
                    )
                  : AppColors.bioElectricGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isVenda ? 'VENDA' : 'ALUGUEL',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        // Preço flutuante
        Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isVenda ? 'Valor de venda' : 'Aluguel mensal',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                _formatPrice(imovel.preco),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            imovel.bairro.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            imovel.titulo,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildChip(
                  context, Icons.bed_outlined, '${imovel.quartos} quartos'),
              const SizedBox(width: 12),
              _buildChip(context, Icons.straighten_outlined,
                  '${imovel.areaM2.toStringAsFixed(0)}m²'),
              if (imovel.vagas > 0) ...[
                const SizedBox(width: 12),
                _buildChip(context, Icons.directions_car_outlined,
                    '${imovel.vagas} vagas'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    final color = context.colors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return 'R\$ ${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return 'R\$ ${(price / 1000).toStringAsFixed(0)}K';
    }
    return 'R\$ ${price.toStringAsFixed(0)}';
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.bioElectricGradient : null,
          color: selected ? null : context.colors.chipUnselected,
          borderRadius: BorderRadius.circular(24),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : context.colors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

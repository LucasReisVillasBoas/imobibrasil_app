import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/imovel_entity.dart';
import '../providers/imovel_providers.dart';

class ImovelDetailScreen extends ConsumerWidget {
  final int imovelId;
  const ImovelDetailScreen({super.key, required this.imovelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imovelAsync = ref.watch(selectedImovelProvider(imovelId));

    return imovelAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(child: Text('Erro ao carregar: $e')),
      ),
      data: (imovel) {
        if (imovel == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Não encontrado')),
            body: const Center(child: Text('Imóvel não encontrado.')),
          );
        }
        return _ImovelDetailContent(imovel: imovel);
      },
    );
  }
}

class _ImovelDetailContent extends StatefulWidget {
  final ImovelEntity imovel;
  const _ImovelDetailContent({required this.imovel});

  @override
  State<_ImovelDetailContent> createState() => _ImovelDetailContentState();
}

class _ImovelDetailContentState extends State<_ImovelDetailContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.logImovelViewed(
        imovelId: widget.imovel.id,
        titulo: widget.imovel.titulo,
        preco: widget.imovel.preco,
        tipo: widget.imovel.tipo,
        cidade: widget.imovel.cidade,
        bairro: widget.imovel.bairro,
      );
      AnalyticsService.logScreenView(screenName: 'imovel_detail');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(context),
                    _buildCharacteristics(context),
                    _buildDescription(context),
                    _buildLocation(context),
                    const SizedBox(height: 100), // space for bottom bar
                  ],
                ),
              ),
            ],
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  // ── Hero SliverAppBar ──────────────────────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 420,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: _GlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => context.pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: _GlassIconButton(
            icon: Icons.edit_rounded,
            onTap: () {
              AnalyticsService.logEditStarted(imovelId: widget.imovel.id);
              context.push(AppRoutes.editPath(widget.imovel.id));
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero photo
            Hero(
              tag: 'imovel-foto-${widget.imovel.id}',
              child: CachedNetworkImage(
                imageUrl: widget.imovel.foto,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.home_outlined,
                      size: 64, color: Colors.grey),
                ),
              ),
            ),
            // Gradient overlay — top for status bar readability
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Gradient overlay — bottom for glass card blend
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 180,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Type badge + title overlay at bottom of hero
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TypeBadge(tipo: widget.imovel.tipo),
                  const SizedBox(height: 8),
                  Text(
                    widget.imovel.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.imovel.bairro}, ${widget.imovel.cidade}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Glass info card (preço + stats rápidos) ────────────────────────────────

  Widget _buildInfoCard(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.glassBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.glassBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREÇO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.bioElectricGradient.createShader(bounds),
                        child: Text(
                          AppFormatters.toBRL(widget.imovel.preco),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Quick stats — área
                _QuickStat(
                  icon: Icons.straighten_rounded,
                  value: AppFormatters.toArea(widget.imovel.areaM2),
                ),
                const SizedBox(width: 8),
                // Quick stats — quartos
                _QuickStat(
                  icon: Icons.bed_rounded,
                  value: '${widget.imovel.quartos}Q',
                ),
                const SizedBox(width: 8),
                // Quick stats — vagas
                _QuickStat(
                  icon: Icons.directions_car_rounded,
                  value: '${widget.imovel.vagas}V',
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  // ── Características ────────────────────────────────────────────────────────

  Widget _buildCharacteristics(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Características'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.6,
            children: [
              _CharacteristicTile(
                icon: Icons.bed_rounded,
                label: 'Quartos',
                value: '${widget.imovel.quartos}',
              ),
              _CharacteristicTile(
                icon: Icons.bathroom_rounded,
                label: 'Banheiros',
                value: '${widget.imovel.banheiros}',
              ),
              _CharacteristicTile(
                icon: Icons.directions_car_rounded,
                label: 'Vagas',
                value: '${widget.imovel.vagas}',
              ),
              _CharacteristicTile(
                icon: Icons.straighten_rounded,
                label: 'Área',
                value: AppFormatters.toArea(widget.imovel.areaM2),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  // ── Descrição ──────────────────────────────────────────────────────────────

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Descrição'),
          const SizedBox(height: 10),
          Text(
            widget.imovel.descricao,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }

  // ── Localização ────────────────────────────────────────────────────────────

  Widget _buildLocation(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Localização'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.sectionBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.bioElectricGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.imovel.bairro,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.imovel.cidade,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ── Bottom Bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context) {
    final colors = context.colors;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: colors.appBarBackground,
              border: Border(
                top: BorderSide(color: colors.sectionBorder),
              ),
            ),
            child: GradientButton(
              onPressed: () => _handleContact(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'ENTRAR EM CONTATO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContact(BuildContext context) {
    AnalyticsService.logContactRequested(
      imovelId: widget.imovel.id,
      titulo: widget.imovel.titulo,
      tipo: widget.imovel.tipo,
      preco: widget.imovel.preco,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Entraremos em contato sobre "${widget.imovel.titulo}" em breve!',
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String tipo;
  const _TypeBadge({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final isVenda = tipo == 'venda';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: isVenda
            ? const LinearGradient(
                colors: [Color(0xFF0067D8), Color(0xFF004FB3)],
              )
            : AppColors.bioElectricGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isVenda ? AppColors.secondary : AppColors.primary)
                .withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isVenda ? 'VENDA' : 'ALUGUEL',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _QuickStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
    );
  }
}

class _CharacteristicTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CharacteristicTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.sectionBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

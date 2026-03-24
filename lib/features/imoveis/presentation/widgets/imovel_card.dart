import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/imovel_entity.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/formatters.dart';

class ImovelCard extends StatelessWidget {
  final ImovelEntity imovel;
  final VoidCallback onTap;
  final int index;

  const ImovelCard({
    super.key,
    required this.imovel,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildInfo(context),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 80).ms, duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Hero(
          tag: 'imovel-foto-${imovel.id}',
          child: CachedNetworkImage(
            imageUrl: imovel.foto,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: 180,
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              height: 180,
              color: Colors.grey.shade200,
              child: const Icon(Icons.home_outlined, size: 48, color: Colors.grey),
            ),
          ),
        ),

        // Badge tipo (venda/aluguel)
        Positioned(
          top: 12,
          left: 12,
          child: _TipoBadge(tipo: imovel.tipo),
        ),

        // Gradiente + preço
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Text(
              AppFormatters.toBRL(imovel.preco),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            imovel.titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${imovel.bairro}, ${imovel.cidade}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _CharacteristicChip(
                icon: Icons.bed_outlined,
                label: '${imovel.quartos} quartos',
              ),
              const SizedBox(width: 8),
              _CharacteristicChip(
                icon: Icons.straighten_outlined,
                label: AppFormatters.toArea(imovel.areaM2),
              ),
              if (imovel.vagas > 0) ...[
                const SizedBox(width: 8),
                _CharacteristicChip(
                  icon: Icons.directions_car_outlined,
                  label: '${imovel.vagas} vagas',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TipoBadge extends StatelessWidget {
  final String tipo;
  const _TipoBadge({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final isVenda = tipo == 'venda';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isVenda ? AppColors.secondary : AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isVenda ? 'Venda' : 'Aluguel',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CharacteristicChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CharacteristicChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

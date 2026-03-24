import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/theme/app_colors_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/imovel_form_provider.dart';
import '../providers/imovel_providers.dart';

class ImovelFormScreen extends ConsumerStatefulWidget {
  final int? imovelId;
  const ImovelFormScreen({super.key, required this.imovelId});

  @override
  ConsumerState<ImovelFormScreen> createState() => _ImovelFormScreenState();
}

class _ImovelFormScreenState extends ConsumerState<ImovelFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descricaoCtrl;
  late final TextEditingController _precoCtrl;
  late final TextEditingController _cidadeCtrl;
  late final TextEditingController _bairroCtrl;
  late final TextEditingController _quartosCtrl;
  late final TextEditingController _banheirosCtrl;
  late final TextEditingController _vagasCtrl;
  late final TextEditingController _areaCtrl;

  bool get isEditing => widget.imovelId != null;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController();
    _descricaoCtrl = TextEditingController();
    _precoCtrl = TextEditingController();
    _cidadeCtrl = TextEditingController();
    _bairroCtrl = TextEditingController();
    _quartosCtrl = TextEditingController();
    _banheirosCtrl = TextEditingController();
    _vagasCtrl = TextEditingController();
    _areaCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEditing) {
        _loadAndInitForm();
      } else {
        ref.read(imovelFormNotifierProvider.notifier).initEmpty();
      }
    });
  }

  Future<void> _loadAndInitForm() async {
    final imoveis = await ref.read(imoveisNotifierProvider.future);
    final imovel = imoveis.where((i) => i.id == widget.imovelId).firstOrNull;

    if (imovel != null && mounted) {
      ref.read(imovelFormNotifierProvider.notifier).initFromEntity(imovel);
      setState(() {
        _tituloCtrl.text = imovel.titulo;
        _descricaoCtrl.text = imovel.descricao;
        _precoCtrl.text = imovel.preco.toString();
        _cidadeCtrl.text = imovel.cidade;
        _bairroCtrl.text = imovel.bairro;
        _quartosCtrl.text = imovel.quartos.toString();
        _banheirosCtrl.text = imovel.banheiros.toString();
        _vagasCtrl.text = imovel.vagas.toString();
        _areaCtrl.text = imovel.areaM2.toString();
      });
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _precoCtrl.dispose();
    _cidadeCtrl.dispose();
    _bairroCtrl.dispose();
    _quartosCtrl.dispose();
    _banheirosCtrl.dispose();
    _vagasCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final formNotifier = ref.read(imovelFormNotifierProvider.notifier);
    final formState = ref.read(imovelFormNotifierProvider);
    formNotifier.setLoading(true);

    try {
      if (isEditing) {
        final imoveis = ref.read(imoveisNotifierProvider).value ?? [];
        final original =
            imoveis.where((i) => i.id == widget.imovelId).firstOrNull;

        final updated = formState.toEntity(
          id: widget.imovelId!,
          foto: original?.foto ?? 'https://picsum.photos/seed/novo/600/400',
        );

        await ref.read(imoveisNotifierProvider.notifier).saveImovel(updated);
        await AnalyticsService.logImovelEdited(
          imovelId: widget.imovelId!,
          tipo: formState.tipo,
          preco: double.tryParse(formState.preco) ?? 0,
        );

        if (mounted) {
          _showSuccessSnackBar('Imóvel atualizado com sucesso!');
          context.pop();
        }
      } else {
        final newImovel = formState.toEntity(
          foto:
              'https://picsum.photos/seed/novo${DateTime.now().millisecondsSinceEpoch}/600/400',
        );

        await ref
            .read(imoveisNotifierProvider.notifier)
            .createImovel(newImovel);
        await AnalyticsService.logImovelCreated(
          tipo: formState.tipo,
          preco: double.tryParse(formState.preco) ?? 0,
          cidade: formState.cidade,
        );

        if (mounted) {
          _showSuccessSnackBar('Imóvel cadastrado com sucesso!');
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(imovelFormNotifierProvider.notifier).setLoading(false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(imovelFormNotifierProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      backgroundColor: context.colors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, isLoading),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).padding.top + kToolbarHeight + 16,
            20,
            40,
          ),
          children: [
            _buildPageHeader(context),
            const SizedBox(height: 24),

            // Seção: Informações Básicas
            _buildSection(
              context,
              icon: Icons.info_outline_rounded,
              title: 'INFORMAÇÕES BÁSICAS',
              delay: 0,
              children: [
                _buildField(
                  controller: _tituloCtrl,
                  label: 'TÍTULO',
                  hint: 'Ex: Apartamento Centro',
                  icon: Icons.title_rounded,
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setTitulo,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Título obrigatório' : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _descricaoCtrl,
                  label: 'DESCRIÇÃO',
                  hint: 'Descreva o imóvel...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  onChanged: ref
                      .read(imovelFormNotifierProvider.notifier)
                      .setDescricao,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Descrição obrigatória' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(formState),
              ],
            ),

            const SizedBox(height: 16),

            // Seção: Localização
            _buildSection(
              context,
              icon: Icons.location_on_outlined,
              title: 'LOCALIZAÇÃO',
              delay: 100,
              children: [
                _buildField(
                  controller: _cidadeCtrl,
                  label: 'CIDADE',
                  hint: 'Ex: Presidente Prudente',
                  icon: Icons.location_city_outlined,
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setCidade,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Cidade obrigatória' : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _bairroCtrl,
                  label: 'BAIRRO',
                  hint: 'Ex: Centro',
                  icon: Icons.map_outlined,
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setBairro,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Bairro obrigatório' : null,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Seção: Valores
            _buildSection(
              context,
              icon: Icons.attach_money_rounded,
              title: 'VALORES',
              delay: 200,
              children: [
                _buildField(
                  controller: _precoCtrl,
                  label: r'PREÇO (R$)',
                  hint: 'Ex: 1800.00',
                  icon: Icons.monetization_on_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setPreco,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Preço obrigatório';
                    final val = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                    if (val <= 0) return 'Preço deve ser maior que zero';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _areaCtrl,
                  label: 'ÁREA (m²)',
                  hint: 'Ex: 65',
                  icon: Icons.straighten_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setAreaM2,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Área obrigatória';
                    final val = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                    if (val <= 0) return 'Área deve ser maior que zero';
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Seção: Características
            _buildSection(
              context,
              icon: Icons.home_outlined,
              title: 'CARACTERÍSTICAS',
              delay: 300,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _quartosCtrl,
                        label: 'QUARTOS',
                        hint: '0',
                        icon: Icons.bed_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: ref
                            .read(imovelFormNotifierProvider.notifier)
                            .setQuartos,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _banheirosCtrl,
                        label: 'BANHEIROS',
                        hint: '0',
                        icon: Icons.bathroom_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: ref
                            .read(imovelFormNotifierProvider.notifier)
                            .setBanheiros,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _vagasCtrl,
                  label: 'VAGAS DE GARAGEM',
                  hint: '0',
                  icon: Icons.directions_car_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged:
                      ref.read(imovelFormNotifierProvider.notifier).setVagas,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Botão Salvar
            GradientButton(
              onPressed: isLoading ? null : _handleSave,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          isEditing ? 'SALVAR ALTERAÇÕES' : 'CADASTRAR IMÓVEL',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 12),

            // Botão Cancelar
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      AnalyticsService.logFormCancelled(isEditing: isEditing);
                      context.pop();
                    },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  // ── AppBar glassmorphism ───────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isLoading) {
    final colors = context.colors;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: colors.appBarBackground,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: colors.textPrimary,
                ),
                onPressed: () {
                  AnalyticsService.logFormCancelled(isEditing: isEditing);
                  context.pop();
                },
              ),
              title: Text(
                isEditing ? 'Editar Imóvel' : 'Novo Imóvel',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header com gradiente ───────────────────────────────────────────────────

  Widget _buildPageHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.bioElectricGradient.createShader(bounds),
          child: Text(
            isEditing ? 'Editar Imóvel' : 'Novo Imóvel',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isEditing
              ? 'Atualize os detalhes do imóvel.'
              : 'Cadastre um novo imóvel na plataforma.',
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  // ── Seção com ícone gradiente ──────────────────────────────────────────────

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int delay,
    required List<Widget> children,
  }) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.sectionBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.sectionBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.bioElectricGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: colors.divider,
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  // ── Campo com label uppercase ──────────────────────────────────────────────

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: AppColors.outline),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  // ── Dropdown tipo ──────────────────────────────────────────────────────────

  Widget _buildDropdown(ImovelFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIPO',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        FormField<String>(
          initialValue: formState.tipo,
          builder: (field) => InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.sell_outlined,
                  size: 18, color: AppColors.outline),
              errorText: field.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: formState.tipo,
                isDense: true,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: context.colors.textPrimary,
                ),
                items: const [
                  DropdownMenuItem(value: 'venda', child: Text('Venda')),
                  DropdownMenuItem(value: 'aluguel', child: Text('Aluguel')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    field.didChange(v);
                    ref.read(imovelFormNotifierProvider.notifier).setTipo(v);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

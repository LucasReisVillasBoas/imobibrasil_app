import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/analytics/analytics_service.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors_scheme.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_provider.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authNotifierProvider, (_, next) async {
      if (next.status == AuthStatus.authenticated) {
        await AnalyticsService.logLogin();
        if (context.mounted) context.go('/imoveis');
      } else if (next.status == AuthStatus.error) {
        AnalyticsService.logLoginFailed();
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          _buildBackgroundBlobs(),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(context),
                    const SizedBox(height: 40),
                    _buildGlassCard(context, authState, isLoading),
                    const SizedBox(height: 24),
                    _buildTestCredentials(),
                  ],
                ),
              ),
            ),
            // Botão de toggle de tema — topo direito
            const Positioned(
              top: 8,
              right: 8,
              child: _ThemeToggleButton(),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlobs() {
    return Stack(
      children: [
        // Blob verde — top-left
        Positioned(
          top: -120,
          left: -120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.12, 1.12),
                duration: 4000.ms,
                curve: Curves.easeInOut,
              ),
        ),
        // Blob azul — bottom-right
        Positioned(
          bottom: -100,
          right: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.20),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(1.1, 1.1),
                end: const Offset(1.0, 1.0),
                duration: 3500.ms,
                curve: Curves.easeInOut,
              ),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Column(
      children: [
        // Ícone SVG da ImobiBrasil
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            kIconAsset,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => const Icon(
              Icons.home_work_rounded,
              color: AppColors.primary,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Logo completo SVG da ImobiBrasil
        SvgPicture.asset(
          kLogoAsset,
          height: 36,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => const Icon(
            Icons.home_work_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildGlassCard(
      BuildContext context, AuthState authState, bool isLoading) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colors.glassBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.glassBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acesse sua experiência imobiliária premium.',
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),

                // Campo e-mail
                _buildInputField(
                  controller: _emailController,
                  label: 'E-MAIL',
                  hint: 'exemplo@imobi.com',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o e-mail';
                    if (!v.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Campo senha
                _buildInputField(
                  controller: _passwordController,
                  label: 'SENHA',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  onFieldSubmitted: (_) => _handleLogin(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe a senha';
                    if (v.length < 4) return 'Senha muito curta';
                    return null;
                  },
                ),

                // Erro de autenticação
                if (authState.status == AuthStatus.error &&
                    authState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).shake(),
                ],

                const SizedBox(height: 28),

                // Botão entrar com gradiente bio-elétrico
                GradientButton(
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ACESSAR CONTA',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 18),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
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
          obscureText: obscureText,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.outline),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestCredentials() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline,
                  size: 14, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'CREDENCIAIS DE TESTE',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: Text(
                  kLoginEmail,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Row(
            children: [
              Text(
                'Senha: $kLoginPassword',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: () {
                _emailController.text = kLoginEmail;
                _passwordController.text = kLoginPassword;
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'PREENCHER AUTOMATICAMENTE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms);
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.50),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.6),
                ),
              ),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 20,
                color: isDark ? Colors.white70 : context.colors.iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

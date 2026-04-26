import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class TelaLogin extends ConsumerStatefulWidget {
  const TelaLogin({super.key});

  @override
  ConsumerState<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends ConsumerState<TelaLogin> {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authStateProvider.notifier).loginComEmail(
          _emailCtrl.text.trim(),
          _senhaCtrl.text,
        );
  }

  Future<void> _loginGoogle() async {
    final googleSignIn = GoogleSignIn();
    final account = await googleSignIn.signIn();
    if (account == null) return;
    final auth = await account.authentication;
    if (auth.idToken == null) return;
    if (!mounted) return;
    await ref.read(authStateProvider.notifier).loginComGoogle(auth.idToken!);
  }

  Future<void> _loginApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    if (!mounted) return;
    await ref.read(authStateProvider.notifier).loginComApple(
          credential.identityToken ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    ref.listen(authStateProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao entrar. Verifique seus dados.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Logo / título
                Text(
                  'Agenda AI',
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.primary,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Encontre os melhores serviços perto de você',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),

                const SizedBox(height: 48),

                // Email
                AppTextField(
                  controller: _emailCtrl,
                  label: 'E-mail',
                  hint: 'seu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'E-mail inválido' : null,
                ),
                const SizedBox(height: 12),

                // Senha
                AppTextField(
                  controller: _senhaCtrl,
                  label: 'Senha',
                  hint: '••••••••',
                  obscureText: !_senhaVisivel,
                  suffix: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondaryLight,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Senha muito curta' : null,
                ),

                const SizedBox(height: 24),

                // Botão entrar
                AppButton(
                  label: 'Entrar',
                  onPressed: isLoading ? null : _loginEmail,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: AppTextStyles.caption.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 16),

                // Google
                _SocialButton(
                  label: 'Continuar com Google',
                  icon: 'G',
                  color: const Color(0xFF4285F4),
                  onPressed: isLoading ? null : _loginGoogle,
                ),
                const SizedBox(height: 10),

                // Apple
                _SocialButton(
                  label: 'Continuar com Apple',
                  icon: '',
                  color: Colors.black,
                  onPressed: isLoading ? null : _loginApple,
                  isApple: true,
                ),
                const SizedBox(height: 10),

                // OTP
                TextButton(
                  onPressed: () => context.push('/otp'),
                  child: Text(
                    'Usar número de telefone',
                    style: AppTextStyles.body.copyWith(color: AppColors.primary),
                  ),
                ),

                const SizedBox(height: 24),

                // Criar conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não tem conta? ',
                        style: AppTextStyles.body),
                    GestureDetector(
                      onTap: () => context.push('/cadastro'),
                      child: Text(
                        'Criar conta',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isApple;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
    this.isApple = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: isApple
            ? const Icon(Icons.apple, color: Colors.black)
            : Text(
                icon,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 18),
              ),
        label: Text(label, style: AppTextStyles.button),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

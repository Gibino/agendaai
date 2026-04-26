import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class TelaConfiguracoes extends ConsumerWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final usuario = authState.valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Nome
            Text(
              usuario?.name ?? 'Usuário',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 4),

            // Email / Telefone
            if (usuario?.email != null)
              Text(
                usuario!.email!,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            if (usuario?.phone != null)
              Text(
                usuario!.phone!,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),

            const SizedBox(height: 40),

            // Seção de opções
            _SettingsItem(
              icon: Icons.edit_rounded,
              label: 'Editar perfil',
              onTap: () {}, // TODO: tela de edição
            ),
            _SettingsItem(
              icon: Icons.notifications_rounded,
              label: 'Notificações',
              onTap: () {}, // TODO
            ),
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              label: 'Versão do app',
              trailing: Text(
                '1.0.0',
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              onTap: null,
            ),

            const SizedBox(height: 32),

            // Botão sair
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).sair();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: const Text(
                'Sair',
                style: TextStyle(color: Colors.redAccent),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: AppTextStyles.body),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

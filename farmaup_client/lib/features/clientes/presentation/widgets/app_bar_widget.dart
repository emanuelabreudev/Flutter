import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// AppBar responsiva da aplicação PharmaIA
/// Implementa menu hambúrguer para mobile e navegação completa para desktop
class PharmaIAAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PharmaIAAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 72,
      leading: isMobile || isTablet ? _buildMenuButton(context) : null,
      automaticallyImplyLeading: false,
      title: isMobile || isTablet
          ? _buildLogo()
          : Row(
              children: [
                _buildLogo(),
                const Spacer(),
                _buildDesktopMenu(context),
              ],
            ),
      actions: isMobile || isTablet
          ? [
              IconButton(
                icon: const Icon(Icons.person_outline_rounded),
                onPressed: () => _showUserMenu(context),
                tooltip: 'Perfil',
              ),
              const SizedBox(width: AppSpacing.xs),
            ]
          : null,
    );
  }

  // ============ LOGO ============
  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.medical_services_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Pharma',
                style: TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'IA',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ DESKTOP MENU ============
  Widget _buildDesktopMenu(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Início'),
        ),
        const SizedBox(width: AppSpacing.xs),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.dashboard_rounded, size: 18),
          label: const Text('Dashboard'),
        ),
        const SizedBox(width: AppSpacing.xs),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.people_rounded, size: 18),
          label: const Text('Clientes'),
        ),
        const SizedBox(width: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.login_rounded, size: 18),
          label: const Text('Acessar plataforma'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
          label: const Text('Fale conosco'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ],
    );
  }

  // ============ MENU BUTTON (Mobile/Tablet) ============
  Widget _buildMenuButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded),
      onPressed: () => _showDrawerMenu(context),
      tooltip: 'Menu',
    );
  }

  // ============ DRAWER MENU (Mobile/Tablet) ============
  void _showDrawerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Título
            Text(
              'Menu de Navegação',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            // Opções de navegação
            _buildDrawerItem(
              context,
              icon: Icons.home_rounded,
              label: 'Início',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.people_rounded,
              label: 'Clientes',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            // Botões de ação
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('Acessar plataforma'),
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Fale conosco'),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ USER MENU (Mobile/Tablet) ============
  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Avatar e informações
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'usuario@pharma.com',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            // Opções de usuário
            _buildDrawerItem(
              context,
              icon: Icons.person_outline_rounded,
              label: 'Meu Perfil',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              label: 'Configurações',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout_rounded,
              label: 'Sair',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

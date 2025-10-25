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
              // Agora o botão de perfil mobile usa a mesma estilização do desktop (avatar circular)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  onTap: () => _showUserMenu(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
            ]
          : [
              // No desktop exibimos o avatar+nome e abrimos um PopupMenu (com mesmo conteúdo estilizado do modal)
              _buildUserAvatarButton(context),
              const SizedBox(width: AppSpacing.sm),
            ],
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

  // ============ DESKTOP MENU (links + ações) ============
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
  /// Mobile/tablet continua abrindo o bottom sheet para consistência com UX móvel.
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

            // Avatar e informações — usa a mesma estilização do avatar do AppBar (desktop)
            Row(
              children: [
                const CircleAvatar(
                  radius:
                      18, // UNIFICADO: mesmo raio usado no AppBar desktop/mobile
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emanuel Abreu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'emanuelabreudev@gmail.com',
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

            // Opções de usuário (mesmo visual do drawer)
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

  // ============ USER AVATAR BUTTON (Desktop) ============
  /// No desktop abrimos um PopupMenu (com conteúdo equivalente ao modal) — padrão web.
  Widget _buildUserAvatarButton(BuildContext context) {
    const String userName = 'Emanuel Abreu';
    const String userEmail = 'emanuelabreudev@gmail.com';

    return PopupMenuButton<int>(
      tooltip: 'Perfil',
      color: Colors.white, // fundo branco do menu no desktop
      elevation: 4,
      offset: const Offset(0, 48),
      // child mostra avatar + nome reduzido no AppBar
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Nome do usuário (limitado)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: const Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => [
        // Cabeçalho com avatar + nome/email (não selecionável)
        PopupMenuItem<int>(
          enabled: false,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      userEmail,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('Meu Perfil'),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Sair'),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            // Navigator.pushNamed(context, '/perfil');
            break;
          case 1:
            // Navigator.pushNamed(context, '/configuracoes');
            break;
          case 2:
            // AuthService.logout();
            break;
        }
      },
    );
  }
}

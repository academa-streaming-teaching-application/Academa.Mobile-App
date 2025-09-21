import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/provider/auth_repositoy_provider.dart';

class ProfileRebrandView extends ConsumerWidget {
  const ProfileRebrandView({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1D1D1E),
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Get current refresh token
        final tokens = ref.read(authTokensProvider);
        final refreshToken = tokens.refreshToken;

        if (refreshToken != null) {
          // Call logout on the repository
          final authRepo = ref.read(authRepositoryProvider);
          await authRepo.logout(refreshToken);
        }

        // Clear tokens from secure storage
        await ref.read(authTokensProvider.notifier).clear();

        // Navigate to login/home screen
        if (context.mounted) {
          context.go('/sign-in');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cerrar sesión: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cuenta',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 6),
              child: Text(
                'PERFIL',
                style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 56),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1D1D1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ProfileRowDetail(
                    rowIcon: Icons.person_outline_rounded,
                    label: 'Name',
                    value: 'Hugo Duque',
                  ),
                  ProfileRowDetail(
                    rowIcon: Icons.mail_outline_rounded,
                    label: 'Mail',
                    value: 'duquehugo08@gmail.com',
                  ),
                  GestureDetector(
                    onTap: () => context.push('/my-subjects'),
                    child: ProfileRowDetail(
                      rowIcon: Icons.school_outlined,
                      label: 'My Subjects',
                      value: '',
                      enableBottomBorder: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 6),
              child: Text(
                'SOBRE',
                style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 56),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1D1D1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ProfileRowDetail(
                    rowIcon: Icons.lock_outline_rounded,
                    label: 'Politica Privacidad',
                    value: '',
                    enableNavigationIcon: false,
                  ),
                  ProfileRowDetail(
                    rowIcon: Icons.library_books_outlined,
                    label: 'Terminos Condiciones',
                    value: '',
                    enableNavigationIcon: false,
                  ),
                  ProfileRowDetail(
                    rowIcon: Icons.info_outline_rounded,
                    label: 'Contactanos',
                    value: '',
                    enableBottomBorder: false,
                    enableNavigationIcon: false,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1D1D1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _handleLogout(context, ref),
                    child: ProfileRowDetail(
                      rowIcon: Icons.logout_rounded,
                      label: 'Cerrar Sesión',
                      value: '',
                      enableNavigationIcon: false,
                    ),
                  ),
                  ProfileRowDetail(
                    rowIcon: Icons.delete_outline_rounded,
                    label: 'Eliminar Cuenta',
                    value: '',
                    mainColor: Colors.red,
                    enableNavigationIcon: false,
                    enableBottomBorder: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRowDetail extends StatelessWidget {
  const ProfileRowDetail(
      {super.key,
      required this.rowIcon,
      required this.label,
      required this.value,
      this.enableBottomBorder = true,
      this.enableNavigationIcon = true,
      this.mainColor = Colors.white});

  final IconData rowIcon;
  final String label;
  final String value;
  final bool enableBottomBorder;
  final bool enableNavigationIcon;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            rowIcon,
            color: mainColor,
            size: 28,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: enableBottomBorder
                  ? Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 54, 54, 56),
                      ),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: mainColor, fontSize: 16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                            color: Color.fromARGB(255, 136, 136, 141),
                            fontSize: 16),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      enableNavigationIcon
                          ? Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color.fromARGB(255, 136, 136, 141),
                              size: 18,
                            )
                          : Icon(null),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

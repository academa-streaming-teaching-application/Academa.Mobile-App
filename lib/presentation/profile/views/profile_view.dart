// lib/presentation/profile/profile_view.dart
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/labeled_fields.dart';
import 'package:academa_streaming_platform/presentation/profile/widgets/custom_profile_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _lastNameCtrl; // 🔸
  late final TextEditingController _roleCtrl; // 🔸

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController(); // 🔸
    _roleCtrl = TextEditingController(); // 🔸
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(authProvider.select((s) => s.user));

    if (user != null) {
      _emailCtrl.text = user.email ?? '';
      _nameCtrl.text = user.name ?? '';
      _lastNameCtrl.text =
          user.lastName ?? ''; // 🔸 ajusta si tu modelo usa otro campo
      _roleCtrl.text = // 🔸 mapea rol → texto
          user.role == 'teacher' ? 'Docente' : 'Estudiante';
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _lastNameCtrl.dispose(); // 🔸
    _roleCtrl.dispose(); // 🔸
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomProfileAppBar(),
      body: CustomBodyContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Correo (solo lectura) ───────────────────────────
              LabeledField(
                label: 'Correo electrónico',
                controller: _emailCtrl,
                labelColor: Colors.black,
                textColor: Colors.black,
                borderColor: Colors.black,
                readOnly: true, // 🔸
              ),
              const SizedBox(height: 24),

              // ── Nombre (editable) ──────────────────────────────
              LabeledField(
                label: 'Nombre',
                controller: _nameCtrl,
                labelColor: Colors.black,
                textColor: Colors.black,
                borderColor: Colors.black,
              ),
              const SizedBox(height: 24),

              // ── Apellido (editable) ────────────────────────────
              LabeledField(
                // 🔸
                label: 'Apellido',
                controller: _lastNameCtrl,
                labelColor: Colors.black,
                textColor: Colors.black,
                borderColor: Colors.black,
              ),
              const SizedBox(height: 24),

              // ── Rol (solo lectura) ────────────────────────────
              LabeledField(
                label: 'Rol',
                controller: _roleCtrl,
                labelColor: Colors.black,
                textColor: Colors.black,
                borderColor: Colors.black,
                readOnly: true, // 🔸
              ),

              const Spacer(),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(size.width, size.height * 0.06),
                  ),
                  onPressed: () {
                    // TODO: Llama a tu endpoint / provider para guardar cambios
                  },
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

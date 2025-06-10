import 'package:academa_streaming_platform/domain/entities/class_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/class_repository_provider.dart';

class SearchClassDelegate extends SearchDelegate<void> {
  @override
  String? get searchFieldLabel => 'Buscar clases…';
  @override
  TextStyle? get searchFieldStyle => const TextStyle(color: Colors.black); // ✨

  /* ─────────────────── ACTIONS ─────────────────── */

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.black), // ✨
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        ),
      ];

  /* ─────────────────── LEADING ─────────────────── */

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black), // ✨
        onPressed: () => close(context, null),
      );

  /* ─────────────────── RESULTS ─────────────────── */
  @override
  Widget buildResults(BuildContext context) => const SizedBox.shrink();

  /* ────────────────── SUGGESTIONS ───────────────── */

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final classesAsync = ref.watch(fetchAllClassesProvider);

        return classesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (classes) {
            final List<ClassEntity> filtered = query.isEmpty
                ? classes
                : classes
                    .where((c) =>
                        c.title.toLowerCase().contains(query.toLowerCase()))
                    .toList();

            if (filtered.isEmpty) {
              return const Center(
                  child: Text('Sin resultados', // ✨
                      style: TextStyle(color: Colors.black)));
            }

            return Material(
              // ✨ fondo blanco
              color: Colors.white, // ✨
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 0, thickness: .5),
                itemBuilder: (_, i) {
                  final c = filtered[i];

                  return ListTile(
                    leading: Image.asset(
                      'lib/config/assets/productivity_square.png',
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      c.title,
                      style: const TextStyle(color: Colors.black), // ✨
                    ),
                    subtitle: Text(
                      c.description ?? '',
                      style: const TextStyle(color: Colors.black54), // ✨
                    ),
                    onTap: () {
                      close(context, null);
                      context.push('/class-view?id=${c.id}');
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

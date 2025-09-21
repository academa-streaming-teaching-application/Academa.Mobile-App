import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchClassDelegate extends SearchDelegate<void> {
  @override
  String? get searchFieldLabel => 'Buscar clases…';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
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

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildSuggestions(BuildContext context) {
    // No creamos un ProviderScope nuevo; ya existe en la app.
    return Consumer(
      builder: (context, ref, _) {
        // dispara la carga si aún no se realizó
        final allAsync = ref.watch(allSubjectsProvider);
        final filtered = ref.watch(subjectsSearchProvider(query));

        if (allAsync.isLoading) {
          return const _SearchSkeleton();
        }

        if (filtered.isEmpty) {
          return const Center(
            child:
                Text('Sin resultados', style: TextStyle(color: Colors.white70)),
          );
        }

        return Material(
          color: Colors.black,
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(
              height: 0,
              thickness: .5,
              color: Color.fromARGB(255, 50, 50, 50),
            ),
            itemBuilder: (_, i) {
              final s = filtered[i];

              // Campos según tu último provider:
              final title = s.subject ?? 'Clase';
              final subtitle = s.category ?? '';
              final rating = (s.averageRating ?? 0).toStringAsFixed(1);

              return ListTile(
                leading: Image.asset(
                  'lib/config/assets/productivity_square.png',
                  width: 56,
                  fit: BoxFit.cover,
                ),
                title: Text(title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  subtitle.isEmpty ? '⭐ $rating' : '$subtitle  ·  ⭐ $rating',
                  style: const TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  close(context, null);
                  context.push('/subject-view/${s.id}');
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => const ListTile(
        leading: _Box(w: 56, h: 56),
        title: _Box(w: 200, h: 16),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: _Box(w: 160, h: 14),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double w;
  final double h;
  const _Box({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  final List<Map<String, String>> mockClasses = [
    {
      'id': '1',
      'title': 'Introducción a Flutter',
      'description': 'Aprende los fundamentos de Flutter desde cero.'
    },
    {
      'id': '2',
      'title': 'React para principiantes',
      'description': 'Domina los conceptos básicos de React.js.'
    },
    {
      'id': '3',
      'title': 'Python Intermedio',
      'description': 'Estructuras de datos, funciones y más.'
    },
    {
      'id': '4',
      'title': 'Diseño de interfaces',
      'description': 'Buenas prácticas y herramientas modernas.'
    },
  ];

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
    final List<Map<String, String>> filtered = query.isEmpty
        ? mockClasses
        : mockClasses
            .where((c) =>
                c['title']!.toLowerCase().contains(query.trim().toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          'Sin resultados',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return Material(
      color: Colors.black,
      child: ListView.separated(
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 0, thickness: .5),
        itemBuilder: (_, i) {
          final subject = filtered[i];

          return ListTile(
            leading: Image.asset(
              'lib/config/assets/productivity_square.png',
              width: 56,
              fit: BoxFit.cover,
            ),
            title: Text(
              subject['title']!,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              subject['description']!,
              style: const TextStyle(color: Colors.white54),
            ),
            onTap: () {
              close(context, null);
              context.push('/class-view?id=${subject['id']}');
            },
          );
        },
      ),
    );
  }
}

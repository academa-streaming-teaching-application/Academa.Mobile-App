import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final List<String> _data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('You selected: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _data.where((item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(suggestions[i]),
        onTap: () => query = suggestions[i],
      ),
    );
  }
}

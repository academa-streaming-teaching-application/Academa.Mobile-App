import 'package:academa_streaming_platform/presentation/search/widgets/search_class_delegate.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/top_rated_subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTop = ref.watch(
      topRatedSubjectsFutureProvider(
        const TopRatedParams(limit: 10, minRatings: 3),
      ),
    );

    return Scaffold(
      appBar: const SearchAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Clases',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            asyncTop.when(
              // ⬇️ placeholders con el mismo look del UI original
              loading: () => Column(
                children: List.generate(
                  10,
                  (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                    child: _TopRatedCardPlaceholder(),
                  ),
                ),
              ),
              error: (e, _) => Column(
                children: List.generate(
                  4,
                  (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                    child: _TopRatedCardPlaceholder(),
                  ),
                ),
              ),
              data: (subjects) {
                if (subjects.isEmpty) {
                  return Column(
                    children: List.generate(
                      4,
                      (index) => const Padding(
                        padding:
                            EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                        child: _TopRatedCardPlaceholder(),
                      ),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    subjects.length,
                    (index) {
                      final s = subjects[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          left: 8,
                          right: 8,
                        ),
                        child: TopRatedSubjectCard(
                          subject: s,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(104);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.black,
      title: const Text(
        'Búsqueda',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchClassDelegate(),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 72, 72, 75)),
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: Color.fromARGB(255, 72, 72, 75)),
                  SizedBox(width: 8),
                  Text(
                    'Qué te gustaría aprender',
                    style: TextStyle(
                      color: Color.fromARGB(255, 72, 72, 75),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder visual idéntico al card original para loading/error/vacío.
/// Mantiene alturas, colores y paddings del diseño.
class _TopRatedCardPlaceholder extends StatelessWidget {
  const _TopRatedCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // header
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffE4B7FF),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xffE4B7FF),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(width: 8),
              // textos
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // título (alto aprox. de 2 líneas)
                    SizedBox(
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFF1E1E1E)),
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFF1E1E1E)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

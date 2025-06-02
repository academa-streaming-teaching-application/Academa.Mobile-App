import 'package:academa_streaming_platform/presentation/class/widgets/custom_class_view_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/keep_watching.dart';
import 'package:academa_streaming_platform/config/const/banner_test.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:go_router/go_router.dart';

import '../provider/class_by_id_provider.dart';

class ClassView extends ConsumerWidget {
  const ClassView({super.key});
  static const TextStyle _liveLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classId = GoRouterState.of(context).uri.queryParameters['id'];

    if (classId == null) {
      return const Scaffold(
        body: Center(child: Text('No class ID provided')),
      );
    }

    final classAsync = ref.watch(fetchClassByIdProvider(classId));

    final size = MediaQuery.of(context).size;

    return classAsync.when(
      data: (classData) => Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomClassViewAppBar(
          title: classData.type!,
          classId: classData.id,
          teacherId: classData.teacherId!,
        ),
        body: CustomBodyContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      classData.title,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: size.width * 0.2,
                      height: size.height * 0.04,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB300FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Siguiendo',
                          style: _liveLabelStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: CustomButton(
                  text: 'LIVE - PARAMETRIZACIÓN',
                  textColor: Colors.white,
                  backgroundColor: Colors.black,
                  textSize: 16,
                  buttonWidth: size.width,
                  buttonHeight: size.height * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 24.0,
                  ),
                  physics: const ClampingScrollPhysics(),
                  itemCount: keepWatching.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = keepWatching[index];
                    return KeepWatchingCard(
                      cardByPropsWidth: double.infinity,
                      cardByPropsHeight: 100,
                      title: item.title,
                      imagePath: item.imagePath,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

import 'package:academa_streaming_platform/presentation/class/widgets/custom_class_view_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/keep_watching.dart';
import 'package:academa_streaming_platform/config/const/banner_test.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';

class ClassView extends StatelessWidget {
  const ClassView({super.key});
  static const TextStyle _liveLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomClassViewAppBar(),
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
                    'Matemática Básica',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    height: size.height * 0.04,
                    decoration: BoxDecoration(
                      color: Color(0xFFB300FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: const Text(
                        'Siguiendo',
                        style: _liveLabelStyle,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Botón LIVE
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

            // 📌 Aquí envolvemos el ListView en Expanded
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
                    studentCount: item.studentCount,
                    imagePath: item.imagePath,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

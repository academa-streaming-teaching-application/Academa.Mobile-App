import 'package:academa_streaming_platform/config/const/banner_test.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/class_card.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/class_filters.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/horizontal_slider.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/keep_watching.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:flutter/material.dart';
import '../widgets/live_banner.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 0;

  static const List<String> _filters = [
    'Todas',
    'Matemáticas',
    'Ciencia',
    'Arte',
    'Historia',
    'Tecnología',
    'Deportes',
  ];
  static const List<Map<String, dynamic>> _continueWatching = [
    {
      'imagePath': 'lib/config/assets/productivity_square.png',
      'subject': 'Álgebra Lineal',
      'students': 25,
    },
    {
      'imagePath': 'lib/config/assets/productivity_square.png',
      'subject': 'Física Cuántica',
      'students': 18,
    },
    {
      'imagePath': 'lib/config/assets/productivity_square.png',
      'subject': 'Historia del Arte',
      'students': 32,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: CustomBodyContainer(
        child: Column(
          children: [
            LiveBannerSwiper(banners: liveBanners),
            const SizedBox(height: 16),
            FilterBar(
              filters: _filters,
              selectedIndex: _selectedFilterIndex,
              onTap: (i) => setState(() => _selectedFilterIndex = i),
            ),
            const SizedBox(height: 8),
            HorizontalSlider(cards: classCards),
            const SizedBox(height: 16),
            ContinueWatchingSection(items: _continueWatching),
          ],
        ),
      ),
    );
  }
}

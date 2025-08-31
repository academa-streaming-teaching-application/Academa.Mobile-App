// import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart';
// import 'package:academa_streaming_platform/presentation/subject/widgets/custom_class_view_app_bar.dart';
// import 'package:academa_streaming_platform/presentation/home/provider/follow_provider.dart';
// import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
// import 'package:academa_streaming_platform/presentation/widgets/shared/keep_watching.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../provider/class_by_id_provider.dart';

// class ClassView extends ConsumerWidget {
//   const ClassView({super.key});

//   static const TextStyle _liveLabelStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 14,
//     fontWeight: FontWeight.bold,
//   );

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final classId = GoRouterState.of(context).uri.queryParameters['id'];

//     final userRole = ref.watch(
//       authProvider.select((s) => s.user?.role ?? ''),
//     );

//     if (classId == null) {
//       return const Scaffold(
//         body: Center(child: Text('No class ID provided')),
//       );
//     }

//     final classAsync = ref.watch(fetchClassByIdProvider(classId));
//     final savedAssetsAsync =
//         ref.watch(fetchSavedAssetsByClassIdProvider(classId));

//     return classAsync.when(
//       loading: () => const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       ),
//       error: (e, _) => Scaffold(
//         body: Center(child: Text('Error: $e')),
//       ),
//       data: (classData) {
//         // ---------- estado de follow ----------
//         final likedIds = ref.watch(followProvider).value ?? <String>{}; // ✨
//         final isFollowed = likedIds.contains(classData.id); // ✨
//         final size = MediaQuery.of(context).size; // ✨

//         return savedAssetsAsync.when(
//           loading: () => const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           ),
//           error: (e, _) => Scaffold(
//             body: Center(child: Text('Error loading videos: $e')),
//           ),
//           data: (savedAssets) => Scaffold(
//             backgroundColor: Colors.black,
//             appBar: CustomClassViewAppBar(
//                 title: classData.type ?? '',
//                 classId: classData.id,
//                 teacherId: classData.teacherId ?? '',
//                 userRole: userRole),
//             body: CustomBodyContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(32.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           classData.title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         GestureDetector(
//                           // ✨
//                           onTap: () => ref
//                               .read(followProvider.notifier)
//                               .toggle(classData.id), // ✨
//                           child: Container(
//                             width: size.width * 0.2,
//                             height: size.height * 0.04,
//                             decoration: BoxDecoration(
//                               color: isFollowed
//                                   ? const Color(0xFFB300FF) // ✨
//                                   : Colors.black, // ✨
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 isFollowed ? 'Siguiendo' : 'Seguir', // ✨
//                                 style: _liveLabelStyle,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   if (savedAssets.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Text(
//                         'No hay grabaciones disponibles para esta clase.',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     )
//                   else
//                     Expanded(
//                       child: ListView.separated(
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: savedAssets.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 12),
//                         itemBuilder: (context, index) {
//                           final asset = savedAssets[index];
//                           return KeepWatchingCard(
//                             cardByPropsHeight: 100,
//                             title: asset.title ?? 'Video sin título',
//                             imagePath:
//                                 'lib/config/assets/productivity_square.png',
//                             onPlay: () {
//                               context.push(
//                                   '/player?playbackId=${asset.playbackId}');
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

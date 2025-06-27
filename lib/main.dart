import 'package:academa_streaming_platform/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

final firebaseInitProvider = FutureProvider<FirebaseApp>((ref) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return Firebase.app();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(firebaseInitProvider);

    return init.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, _) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error: $err'))),
      ),
      data: (_) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Academa Streaming',
        theme: AppTheme().theme(),
        routerConfig: appRouter,
      ),
    );
  }
}
 
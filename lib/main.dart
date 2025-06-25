import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/app/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tezda_task/firebase_options.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        builder: (_, child) => ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Tezda Task',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          ),
        ),
        splitScreenMode: true,
        minTextAdapt: true,
        designSize: const Size(375, 812),
      ),
    );
  }
}

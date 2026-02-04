import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'data/repositories/audience_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'logic/auth/auth_cubit.dart';
import 'services/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  // Initialize local storage and any other async services here.
  final localStorage = await LocalStorageService.init();

  runApp(SanyuktApp(localStorage: localStorage));
}

class SanyuktApp extends StatelessWidget {
  const SanyuktApp({super.key, required this.localStorage});

  final LocalStorageService localStorage;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(localStorage: localStorage)..bootstrap(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(localStorage: localStorage),
        ),
        RepositoryProvider<AudienceRepository>(
          create: (_) => AudienceRepository(localStorage: localStorage),
        ),
      ],
      child: MaterialApp.router(
        title: 'Sanyukt',
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: buildRouterConfig(),
      ),
    );
  }
}

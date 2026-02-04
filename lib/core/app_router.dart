import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/auth/auth_cubit.dart';
import '../presentation/screens/audience/audience_categories_screen.dart';
import '../presentation/screens/audience/audience_user_detail_screen.dart';
import '../presentation/screens/audience/audience_users_screen.dart';
import '../presentation/screens/business/business_type_selection_screen.dart';
import '../presentation/screens/business/business_users_screen.dart';
import '../presentation/screens/business/industry_categories_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_shell_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouterConfig() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: LoginScreen.routePath,
    redirect: (context, state) {
      final authStatus = context.read<AuthCubit>().state.status;
      final isOnLogin = state.matchedLocation == LoginScreen.routePath;

      if (authStatus == AuthStatus.authenticated || authStatus == AuthStatus.guest) {
        if (isOnLogin) return MainShellScreen.routePath;
      } else if (authStatus == AuthStatus.unauthenticated && !isOnLogin) {
        return LoginScreen.routePath;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: MainShellScreen.routePath,
        name: MainShellScreen.routeName,
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.routeName,
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: ProfileScreen.routePath,
        name: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AudienceCategoriesScreen.routePath,
        name: AudienceCategoriesScreen.routeName,
        builder: (context, state) => const AudienceCategoriesScreen(),
        routes: [
          GoRoute(
            path: ':categoryId',
            name: AudienceUsersScreen.routeName,
            builder: (context, state) => AudienceUsersScreen(
              categoryId: state.pathParameters['categoryId']!,
            ),
            routes: [
              GoRoute(
                path: 'user/:userId',
                name: AudienceUserDetailScreen.routeName,
                builder: (context, state) => AudienceUserDetailScreen(
                  userId: state.pathParameters['userId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: BusinessTypeSelectionScreen.routePath,
        name: BusinessTypeSelectionScreen.routeName,
        builder: (context, state) => const BusinessTypeSelectionScreen(),
        routes: [
          GoRoute(
            path: ':type',
            name: IndustryCategoriesScreen.routeName,
            builder: (context, state) => IndustryCategoriesScreen(
              type: state.pathParameters['type']!,
            ),
            routes: [
              GoRoute(
                path: 'users',
                name: BusinessUsersScreen.routeName,
                builder: (context, state) => BusinessUsersScreen(
                  type: state.pathParameters['type']!,
                  category: state.uri.queryParameters['category'] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/user/:userId',
        name: 'user-detail',
        builder: (context, state) => AudienceUserDetailScreen(
          userId: state.pathParameters['userId']!,
        ),
      ),
    ],
  );
}


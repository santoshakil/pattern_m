import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/logger/logger.s.dart';
import '../../../features/auth/presentation/screens/login.v.dart';
import '../../../features/auth/presentation/screens/register.v.dart';
import '../../../features/home/presentation/screens/home.v.dart';
import '../../../features/settings/presentation/screens/settings.v.dart';
import '../widgets/error_screen.dart';
import '../widgets/splash_screen.dart';
import 'auth.p.dart';

part 'router.p.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: authState,
    
    // Global error handler
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error,
    ),
    
    // Routes
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app routes
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    
    // Redirect logic
    redirect: (context, state) {
      final isAuthenticated = authState.value ?? false;
      final isAuthRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';
      
      Logger.d('Router redirect: authenticated=$isAuthenticated, location=${state.matchedLocation}');
      
      // If on splash, check auth and redirect
      if (isSplash) {
        if (isAuthenticated) {
          return '/';
        } else {
          return '/login';
        }
      }
      
      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      
      // If authenticated and on auth route, redirect to home
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }
      
      // No redirect needed
      return null;
    },
  );
}

// Route extensions
extension GoRouterExtension on BuildContext {
  void navigateToHome() => go('/');
  void navigateToLogin() => go('/login');
  void navigateToRegister() => go('/register');
  void navigateToSettings() => go('/settings');
  
  void replaceWithHome() => pushReplacement('/');
  void replaceWithLogin() => pushReplacement('/login');
}
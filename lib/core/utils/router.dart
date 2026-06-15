import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/auth/presentation/login_screen.dart';
import 'package:roamora/features/home/presentation/home_screen.dart';
import 'package:roamora/features/home/presentation/create_event_screen.dart';
import 'package:roamora/features/planning/presentation/trip_planning_screen.dart';
import 'package:roamora/features/profile/presentation/profile_settings_screen.dart';
import 'package:roamora/features/chat/presentation/chat_screen.dart';
import 'package:roamora/features/chat/presentation/chat_list_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authStateNotifier = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  
  ref.listen(authStateProvider, (_, next) {
    authStateNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      final authState = authStateNotifier.value;
      final isLoggedIn = authState.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/create-event',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CreateEventScreen(
            latitude: extra['lat'] as double,
            longitude: extra['lng'] as double,
          );
        },
      ),
      GoRoute(
        path: '/planning',
        builder: (context, state) => const TripPlanningScreen(),
      ),
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) => ChatScreen(otherUserId: state.pathParameters['id']!),
      ),
    ],
  );
}

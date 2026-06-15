import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/chat/presentation/chat_list_screen.dart';
import 'package:roamora/features/home/presentation/discovery_screen.dart';
import 'package:roamora/features/planning/presentation/trip_planning_screen.dart';
import 'package:roamora/features/profile/presentation/profile_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DiscoveryScreen(),
    const TripPlanningScreen(),
    const ChatListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roamora'),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: profileAsync.when(
              data: (user) => user?.photoURL != null
                  ? CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(user!.photoURL!),
                    )
                  : const Icon(Icons.person),
              loading: () => const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stackTrace) => const Icon(Icons.person),
            ),
          ),
          IconButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Trip Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}

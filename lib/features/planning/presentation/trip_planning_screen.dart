import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roamora/core/utils/location_service.dart';
import 'package:roamora/core/utils/place_service.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/home/data/discovery_repository.dart';
import 'package:roamora/features/home/domain/event_model.dart';
import 'package:roamora/features/planning/data/planning_repository.dart';
import 'package:roamora/features/planning/domain/trip_plan_model.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';
import 'package:uuid/uuid.dart';

class TripPlanningScreen extends ConsumerStatefulWidget {
  const TripPlanningScreen({super.key});

  @override
  ConsumerState<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends ConsumerState<TripPlanningScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login')));

    final plansAsync = ref.watch(userTripPlansProvider(user.uid));
    final eventsAsync = ref.watch(userEventsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            tooltip: 'Add Item',
            onPressed: () {
              final plans = plansAsync.valueOrNull ?? [];
              if (plans.isNotEmpty) {
                _addItemToPlan(plans);
              } else {
                _createNewPlan(user.uid);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'New Trip Plan',
            onPressed: () => _createNewPlan(user.uid),
          ),
        ],
      ),
      body: plansAsync.when(
        data: (plans) => eventsAsync.when(
          data: (events) => _buildUnifiedPlanList(plans, events),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildUnifiedPlanList(List<TripPlanModel> plans, List<EventModel> events) {
    final List<dynamic> allItems = [
      ...plans.expand((p) => p.items),
      ...events,
    ];

    if (allItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No plans yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (plans.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _addItemToPlan(plans),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  final user = ref.read(authRepositoryProvider).currentUser;
                  if (user != null) _createNewPlan(user.uid);
                },
                icon: const Icon(Icons.playlist_add),
                label: const Text('Create Trip Plan'),
              ),
          ],
        ),
      );
    }

    // Sort everything by date
    allItems.sort((a, b) {
      final dateA = (a is TripItemModel ? a.date : (a as EventModel).startTime) ?? DateTime.now();
      final dateB = (b is TripItemModel ? b.date : (b as EventModel).startTime) ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        final isEvent = item is EventModel;
        
        final DateTime itemDate = (isEvent ? (item as EventModel).startTime : (item as TripItemModel).date) ?? DateTime.now();

        // Define the card content
        Widget cardContent = Card(
          margin: EdgeInsets.zero,
          color: isEvent ? Colors.orange[50] : null,
          child: ListTile(
            visualDensity: VisualDensity.compact,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM').format(itemDate).toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isEvent ? Colors.orange : Colors.blue,
                  ),
                ),
                Text(
                  itemDate.day.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            title: _buildTitle(item, isEvent),
            subtitle: _buildSubtitle(item, isEvent),
          ),
        );

        if (isEvent) {
          final event = item as EventModel;
          final currentUser = ref.read(authRepositoryProvider).currentUser;
          
          if (currentUser != null && event.hostId == currentUser.uid) {
            return Dismissible(
              key: Key(event.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                final eventId = event.id;
                try {
                  await ref.read(discoveryRepositoryProvider).deleteEvent(eventId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event deleted')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete event: $e')),
                    );
                  }
                }
              },
              child: cardContent,
            );
          }
        }

        return Container(margin: const EdgeInsets.only(bottom: 8), child: cardContent);
      },
    );
  }

  Future<void> _createNewPlan(String userId) async {
    try {
      final plan = TripPlanModel(
        id: const Uuid().v4(),
        userId: userId,
        title: 'New Trip',
        createdAt: DateTime.now(),
      );
      await ref.read(planningRepositoryProvider).saveTripPlan(plan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New trip plan created and synced to cloud')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save to cloud: $e')),
        );
      }
    }
  }

  Future<void> _addItemToPlan(List<TripPlanModel> plans) async {
    if (plans.isEmpty) return;

    // Get current position or default to 0,0
    final position = await ref.read(currentPositionProvider.future).catchError((_) => Position(
      latitude: 0, longitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
    ));

    if (mounted) {
      GoRouter.of(context).push(
        '/create-event',
        extra: {'lat': position.latitude, 'lng': position.longitude},
      );
    }
  }

  Widget _buildTitle(dynamic item, bool isEvent) {
    if (!isEvent) {
      return Text(
        (item as TripItemModel).description ?? 'Untitled Activity',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }

    final event = item as EventModel;
    return Text(
      event.reason,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange[900]),
    );
  }

  Widget _buildSubtitle(dynamic item, bool isEvent) {
    final DateTime itemDate = (isEvent ? (item as EventModel).startTime : (item as TripItemModel).date) ?? DateTime.now();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isEvent && (item as TripItemModel).locationAddress?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: Colors.grey),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    (item as TripItemModel).locationAddress!,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (isEvent && (item as EventModel).locationAddress?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: Colors.grey),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    (item as EventModel).locationAddress!,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Colors.grey),
              const SizedBox(width: 2),
              Text(
                DateFormat('HH:mm').format(itemDate) +
                (isEvent ? ' - ${DateFormat('HH:mm').format((item as EventModel).endTime)}' : ''),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripItemDialog extends StatefulWidget {
  final WidgetRef ref;
  const _TripItemDialog({required this.ref});

  @override
  State<_TripItemDialog> createState() => _TripItemDialogState();
}

class _TripItemDialogState extends State<_TripItemDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  double _lat = 0;
  double _lng = 0;
  List<PlaceSuggestion> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.length < 3) {
      setState(() => _suggestions = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearching = true);
      final suggestions = await widget.ref.read(placeServiceProvider).getSuggestions(query);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _selectSuggestion(PlaceSuggestion suggestion) async {
    setState(() {
      _locationController.text = suggestion.description;
      _suggestions = [];
    });

    final details = await widget.ref.read(placeServiceProvider).getPlaceDetails(suggestion.placeId);
    if (details != null && mounted) {
      setState(() {
        _lat = details.lat;
        _lng = details.lng;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location Address',
                suffixIcon: _isSearching 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
            if (_suggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return ListTile(
                      title: Text(suggestion.description, style: const TextStyle(fontSize: 12)),
                      onTap: () => _selectSuggestion(suggestion),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date & Time'),
              subtitle: Text(DateFormat('MMM d, HH:mm').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date == null || !context.mounted) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedDate),
                );
                if (time == null || !context.mounted) return;

                setState(() {
                  _selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final item = TripItemModel(
                id: const Uuid().v4(),
                description: _titleController.text,
                locationAddress: _locationController.text,
                latitude: _lat,
                longitude: _lng,
                date: _selectedDate,
              );
              if (context.mounted) {
                Navigator.pop(context, item);
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

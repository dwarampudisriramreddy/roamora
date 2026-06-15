import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roamora/core/utils/place_service.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/home/data/discovery_repository.dart';
import 'package:roamora/features/home/domain/event_model.dart';
import 'package:uuid/uuid.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;

  const CreateEventScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _locationController = TextEditingController();
  
  late double _currentLat;
  late double _currentLng;
  List<PlaceSuggestion> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;

  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 3));

  @override
  void initState() {
    super.initState();
    _currentLat = widget.latitude;
    _currentLng = widget.longitude;
  }

  @override
  void dispose() {
    _reasonController.dispose();
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
      final suggestions = await ref.read(placeServiceProvider).getSuggestions(query);
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

    final details = await ref.read(placeServiceProvider).getPlaceDetails(suggestion.placeId);
    if (details != null && mounted) {
      setState(() {
        _currentLat = details.lat;
        _currentLng = details.lng;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must be logged in to create an event.')));
      return;
    }

    final event = EventModel(
      id: const Uuid().v4(),
      hostId: user.uid,
      reason: _reasonController.text,
      locationAddress: _locationController.text,
      latitude: _currentLat,
      longitude: _currentLng,
      startTime: _startTime,
      endTime: _endTime,
      participants: [user.uid],
    );

    // Show a loading indicator so it doesn't just look like nothing is happening
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      debugPrint('Attempting to create event...');
      // Use a timeout so we don't hang indefinitely if Firestore is unreachable
      await ref.read(discoveryRepositoryProvider).createEvent(event).timeout(const Duration(seconds: 5));
      debugPrint('Event created successfully.');
      
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } catch (e) {
      debugPrint('Error creating event: $e');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event (Firebase might not be configured): $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Please enter a reason' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text('${_startTime.toLocal()}'.split('.')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null && mounted) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (time != null) {
                    setState(() {
                      _startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      if (_endTime.isBefore(_startTime)) {
                        _endTime = _startTime.add(const Duration(hours: 2));
                      }
                    });
                  }
                }
              },
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text('${_endTime.toLocal()}'.split('.')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endTime,
                  firstDate: _startTime,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null && mounted) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endTime),
                  );
                  if (time != null) {
                    setState(() {
                      _endTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Search Location',
                    border: const OutlineInputBorder(),
                    suffixIcon: _isSearching 
                      ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
                if (_suggestions.isNotEmpty)
                  Card(
                    elevation: 4,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          title: Text(suggestion.description),
                          onTap: () => _selectSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLat, _currentLng),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: LatLng(_currentLat, _currentLng),
                    ),
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Publish Event', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

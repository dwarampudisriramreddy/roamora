import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roamora/core/utils/location_service.dart';
import 'package:roamora/features/auth/data/auth_repository.dart';
import 'package:roamora/features/home/data/discovery_repository.dart';
import 'package:roamora/features/home/domain/event_model.dart';
import 'package:roamora/features/home/presentation/discovery_mode_controller.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final Map<String, BitmapDescriptor> _eventMarkers = {};
  EventModel? _selectedEvent;
  String? _selectedHostEmail;
  String? _selectedHostId;

  Future<void> _generateEventMarkers(List<EventModel> events) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    bool updated = false;
    for (final event in events) {
      final dateStr = DateFormat('MMM d').format(event.startTime);
      if (!_eventMarkers.containsKey(event.id)) {
        final isMyEvent = event.hostId == currentUser?.uid;
        final color = isMyEvent ? Colors.red : Colors.orange;
        final marker = await _createDateMarker(dateStr, color);
        _eventMarkers[event.id] = marker;
        updated = true;
      }
    }
    if (updated && mounted) {
      setState(() {});
    }
  }

  Future<BitmapDescriptor> _createDateMarker(String date, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    const double width = 40.0;
    const double height = 55.0;

    // Draw pin body (circle)
    canvas.drawCircle(const Offset(width / 2, width / 2), width / 2, paint);

    // Draw pin tip (triangle)
    final path = Path()
      ..moveTo(width * 0.2, width * 0.8)
      ..lineTo(width / 2, height)
      ..lineTo(width * 0.8, width * 0.8)
      ..close();
    canvas.drawPath(path, paint);

    // Draw inner white circle for better contrast
    canvas.drawCircle(const Offset(width / 2, width / 2), width * 0.4, Paint()..color = Colors.white.withValues(alpha: 0.2));

    // Draw text
    final TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: date,
      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(canvas, Offset((width - painter.width) / 2, (width - painter.height) / 2));

    final ui.Image image = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    final initialPositionAsync = ref.watch(currentPositionProvider);
    final discoveryMode = ref.watch(discoveryModeControllerProvider);
    final travelersAsync = ref.watch(nearbyTravelersProvider(discoveryMode));
    final eventsAsync = ref.watch(nearbyEventsProvider(discoveryMode));

    // Handle initial and updated data
    if (eventsAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _generateEventMarkers(eventsAsync.value!);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          initialPositionAsync.when(
            data: (position) {
              final markers = _buildMarkers(
                travelers: travelersAsync.valueOrNull ?? [],
                events: eventsAsync.valueOrNull ?? [],
              );

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: markers,
                onMapCreated: (controller) {
                  // Map initialized
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SegmentedButton<DiscoveryMode>(
                  segments: const [
                    ButtonSegment(
                      value: DiscoveryMode.mine,
                      label: Text('My', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.person_pin_circle, size: 16),
                    ),
                    ButtonSegment(
                      value: DiscoveryMode.all,
                      label: Text('All', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.public, size: 16),
                    ),
                    ButtonSegment(
                      value: DiscoveryMode.womenOnly,
                      label: Text('Women', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.female, size: 16),
                    ),
                  ],
                  selected: {discoveryMode},
                  onSelectionChanged: (newSelection) {
                    ref.read(discoveryModeControllerProvider.notifier).setDiscoveryMode(newSelection.first);
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    selectedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  showSelectedIcon: false,
                ),
              ),
            ),
          ),
          if (_selectedEvent != null)
            Positioned(
              bottom: 90,
              left: 16,
              right: 16,
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedEvent!.reason,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => setState(() => _selectedEvent = null),
                            child: const Icon(Icons.close, size: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.white70),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              DateFormat('MMM d, HH:mm').format(_selectedEvent!.startTime),
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Colors.white70),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _selectedEvent!.hostId == ref.read(authRepositoryProvider).currentUser?.uid 
                                  ? 'You' 
                                  : 'Traveller: ${_selectedHostEmail ?? '...'}',
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedEvent!.hostId != ref.read(authRepositoryProvider).currentUser?.uid) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.push('/chat/$_selectedHostId');
                              setState(() => _selectedEvent = null);
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.white),
                            label: const Text('Message', style: TextStyle(fontSize: 12, color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          initialPositionAsync.whenData((position) {
            context.push(
              '/create-event',
              extra: {'lat': position.latitude, 'lng': position.longitude},
            );
          });
        },
        label: const Text('Create Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Set<Marker> _buildMarkers({
    required List<UserModel> travelers,
    required List<EventModel> events,
  }) {
    final Set<Marker> markers = {};
    final currentUser = ref.read(authRepositoryProvider).currentUser;

    for (final traveler in travelers) {
      // Avoid showing the current user as a marker
      if (traveler.uid == currentUser?.uid) continue;
      
      if (traveler.latitude != null && traveler.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId('traveler_${traveler.uid}'),
            position: LatLng(traveler.latitude!, traveler.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: traveler.email,
              snippet: traveler.interests.isNotEmpty ? traveler.interests.join(', ') : 'Traveler',
              onTap: () => _showUserDetails(context, traveler),
            ),
          ),
        );
      }
    }

    for (final event in events) {
      final isCurrentUser = currentUser?.uid == event.hostId;
      
      markers.add(
        Marker(
          markerId: MarkerId('event_${event.id}'),
          position: LatLng(event.latitude, event.longitude),
          icon: _eventMarkers[event.id] ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () async {
            setState(() {
              _selectedEvent = event;
            });
            if (isCurrentUser) {
              setState(() {
                _selectedHostEmail = currentUser?.email ?? 'Your Email';
                _selectedHostId = event.hostId;
              });
            } else {
              // Fetch host profile on tap
              final UserModel? hostProfile = await ref.read(userProfileProvider(event.hostId).future);
              if (mounted) {
                setState(() {
                  final hostEmail = hostProfile?.email ?? '';
                  _selectedHostEmail = hostEmail.isNotEmpty ? hostEmail : 'Unknown';
                  _selectedHostId = event.hostId;
                });
              }
            }
          },
        ),
      );
    }

    return markers;
  }

  void _showUserDetails(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                  child: user.photoURL == null ? const Icon(Icons.person, size: 30) : null,
                ),
                const SizedBox(height: 8),
                Text(user.email, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/chat/${user.uid}');
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat with User'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

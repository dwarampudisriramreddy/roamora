import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/home/data/discovery_repository.dart';
import 'package:roamora/features/home/domain/event_model.dart';

part 'create_event_controller.g.dart';

@riverpod
class CreateEventController extends _$CreateEventController {
  @override
  FutureOr<void> build() {}

  Future<void> createEvent(EventModel event) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(discoveryRepositoryProvider).createEvent(event);
    });
  }
}

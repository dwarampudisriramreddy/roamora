import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'discovery_mode_controller.g.dart';

@riverpod
class DiscoveryModeController extends _$DiscoveryModeController {
  @override
  DiscoveryMode build() {
    return DiscoveryMode.all;
  }

  void toggleDiscoveryMode() {
    if (state == DiscoveryMode.all) {
      state = DiscoveryMode.womenOnly;
    } else {
      state = DiscoveryMode.all;
    }
  }

  void setDiscoveryMode(DiscoveryMode mode) {
    state = mode;
  }
}

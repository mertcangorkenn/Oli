import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/domain/di/dependency_manager.dart';
import 'package:listing/app/profile/profile_notifier.dart';
import 'package:listing/app/profile/profile_state.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(userRepository),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/register/register_state.dart';
import 'register_notifier.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(),
);
